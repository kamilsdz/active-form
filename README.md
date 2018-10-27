# ActiveObjects 
Form objects for Ruby on Rails.
* Works with ActiveRecord
* i18n support
* Easy to implement

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_objects'
```

And then execute:

    $ bundle

## Usage

### Rails: 

#### Create first form object
Create a forms directory, for example: app/forms and create your first form object there:
```ruby
class ProductForm < ActiveObjects
  validates :name, presence: true
 
  private
 
  def object_class
    Product
  end
 
  def permitted_attributes
    %i[name]
  end
end
```
Where object_class (for model class) and permitted_attributes (for model attributes from the form) are required methods.

To load forms, add this line to config/application.rb
```ruby
    config.autoload_paths << Rails.root.join('app/forms/**/')
```

In the form object you have access to all [ActiveModel validations](https://api.rubyonrails.org/classes/ActiveModel/Validations.html)

#### Update your controller actions

```ruby
  def new 
    @product_form = ProductForm.new
  end
  
  def edit
    product =  Product.find(params[:id])
    @product_form = ProductForm.new(product)
  end
 
  def create
    @product_form = ProductForm.new(product_params)
    if @product_form.save
      redirect_to products_path
    else 
      render :new
    end
  end
 
  def update
    product = Product.find(params[:id])
    @product_form = ProductForm.new(product)
    if @product_form.update(product_params)
      redirect_to products_path
    else
      render :edit
    end
  end
```
#### Update your views

New:
```ruby
= form_for(@product_form, url: products_path, method: :post) do |f|
  = f.text_field :name
  %small= f.object.errors[:name]&.first 
  = f.submit
```
Edit:
```ruby
= form_for(@product_form, url: product_path(@product), method: :patch) do |f|
  = f.text_field :name
  %small= f.object.errors[:name]&.first
  = f.submit
```

#### i18n

Activeform uses standard ActiveRecord i18n scope for error messages and model names and attributes. 
```yaml
en:
  activerecord:
    attributes:
      Product:
        name:  Name
        price: Price
    models:
      product:
        one: Product 
        other: Products 
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kamilsdz/active_objects. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Activeform project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kamilsdz/active_objects/blob/master/CODE_OF_CONDUCT.md).
