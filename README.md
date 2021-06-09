# DEPRECATED - no longer actively maintained
# Rails Pallet
[![Gem Version](https://badge.fury.io/rb/rails_pallet.svg)](https://badge.fury.io/rb/rails_pallet)
[![Build Status](https://travis-ci.org/platanus/rails_pallet.svg?branch=master)](https://travis-ci.org/platanus/rails_pallet)
[![Coverage Status](https://coveralls.io/repos/github/platanus/rails_pallet/badge.svg)](https://coveralls.io/github/platanus/rails_pallet)

Rails engine to save [paperclip](https://github.com/thoughtbot/paperclip) attachments asynchronously. For example, if you have an `User` model with `avatar` paperclip attribute, you will:

1. Create a new upload instance to hold the avatar file temporarily.
1. Create a new user passing the upload id or instance as parameter.

## Installation

Add to your Gemfile...

```ruby
gem 'rails_pallet'
```

Run the installer:

```shell
$ rails generate rails_pallet:install
```

Then, add an attachment, as usually do, using paperclip.

```shell
$ rails generate paperclip user avatar
```

Inside `User` model, you need to execute `has_attached_upload` instead the `has_attached_file` paperclip's method:

```ruby
class User < ActiveRecord::Base
  has_attached_upload :avatar, path: ':rails_root/tmp/users/:id/:filename'
  do_not_validate_attachment_file_type :avatar
end
```

## Usage

### Using `upload_identifier`

**First**: you need to save an upload instance.
The engine creates the `POST /uploads` endpoint to achieve this.
After perform a `POST` to `/uploads` with a `file` param, you will get this response:

```json
{
    "upload": {
        "identifier": "rW6q2QZM",
        "file_extension": "jpg",
        "file_name": "90033441_BLO_20150607",
        "download_url": "http://my-server.com/uploads/rW6q2QZM/download"
    }
}
```

**Second**: supposing you have an `UsersController`, you need to perform a `POST /users` to create a new user passing the upload identifier you get previously.

```ruby
class UsersController < ApplicationController
  def create
    respond_with User.create(permitted_params)
  end

  private

  def permitted_params
    params.require(:user).permit(:upload_identifier)
  end
end
```

### Using `upload`

You can do something like this:

```ruby
class UsersController < ApplicationController
  def create
    @user = User.new
    @user.upload = RailsPallet::Upload.create(file: params[:file])
    @user.save!
    respond_with @user
  end
end
```

### Using prefix

You will need a way to match an upload resource with a specific attribute if you have two or more paperclip attributes on the same model. To do this, you can pass the option `upload: { use_prefix: true }` on `has_attached_upload` like this:

```ruby
class User < ActiveRecord::Base
  has_attached_upload :avatar, path: ':rails_root/tmp/users/:id/:filename', upload: { use_prefix: true }
  has_attached_upload :document, path: ':rails_root/tmp/users/:id/:filename', upload: { use_prefix: true }
  has_attached_upload :photo, path: ':rails_root/tmp/users/:id/:filename'
end
```

Then, in your controller...

```ruby
class UsersController < ApplicationController
  def create
    respond_with User.create(permitted_params)
  end

  private

  def permitted_params
    params.require(:user).permit(:avatar_upload_identifier, :document_upload_identifier, :upload_identifier)
  end
end
```

or using the upload object...

```ruby
class UsersController < ApplicationController
  def create
    @user = User.new
    @user.avatar_upload = RailsPallet::Upload.create(file: params[:avatar])
    @user.document_upload = RailsPallet::Upload.create(file: params[:document])
    @user.upload = RailsPallet::Upload.create(file: params[:photo])
    @user.save!
    respond_with @user
  end
end
```

> If you execute `has_attached_upload` method two or more times in same model with `upload: { use_prefix: false }` (false is the default value), you will be obligated to use the `upload: { use_prefix: true }` option. If you don't, an exception will be raised.

### Base64 Encoding

If you want to save base64 encoded attachments, you can execute the `allow_encoded_file_for` method:

```ruby
class User < ActiveRecord::Base
  has_attached_upload :avatar, path: ':rails_root/tmp/users/:id/:filename'
  allow_encoded_file_for :avatar
  do_not_validate_attachment_file_type :avatar
end
```

And then...

```ruby
class UsersController < ApplicationController
  def create
    respond_with User.create(permitted_params)
  end

  private

  def permitted_params
    params.require(:user).permit(:encoded_avatar)
    # encoded_avatar param must hold the encoded file
  end
end
```

### Creating your own `UploadsController`

You can generate your own `UploadsController` if for example:

* your controllers don't inherit from the `ApplicationController`
* you want to change the default route for `UploadsController`. (Also you can map the default controller with another route in your `routes.rb`)
* you want to add extra logic to the default `UploadsController`

Running...

```shell
$ rails generate rails_pallet:upload_controller api/uploads api/base
```

You will get in `your_app/app/controllers/api/uploads_controller.rb`

```ruby
class Api::UploadsController < Api::BaseController
  self.responder = RailsPalletResponder
  respond_to :json

  def create
    new_upload = RailsPallet::Upload.create(permitted_params)
    respond_with new_upload, status: :created
  end

  private

  def permitted_params
    params.permit(:file)
  end

  def upload
    @upload ||= RailsPallet::Upload.find_by_identifier(params[:identifier])
  end
end
```

and the route...

```ruby
post "api/uploads", to: "api/uploads#create", defaults: { format: :json }
```

## Configuration

You can change the engine configuration from `your_app/config/initializers/rails_pallet.rb`

#### Configuration Options:

* `hash_salt`: The upload module uses a salt string to generate an unique hash for each instance. A salt string can be defined here to replace the default and increase the module's security.

* `use_prefix`: false by default. If true, you will need to pass `[host_model_paperclip_attribute_name]_+upload|upload_identifier` instead just `upload` or `upload_identifier` to the host model to use an upload resource.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Thank you [contributors](https://github.com/platanus/rails_pallet/graphs/contributors)!

<img src="http://platan.us/gravatar_with_text.png" alt="Platanus" width="250"/>

rails_pallet is maintained by [platanus](http://platan.us).

## License

Rails Pallet is © 2017 Platanus, spa. It is free software and may be redistributed under the terms specified in the LICENSE file.
