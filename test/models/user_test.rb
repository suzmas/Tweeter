require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup #Sets up our instance vars to be used w/i each test
    @user = User.new(name: "Suzan", email: "suzan@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM a_US@foo.bar.org first.last@foo.jp]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should not accept invalid email addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.com user@example. foofoo@bar_baz.com foo@bar+baz.com fooface@bler..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase # test for case insensitivity
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses should save as lower-case" do
    mixed_case_email = "FoO@eXamPlE.cOm"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should not be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have minimum length" do
    @user.password = @user.password_confirmation = " " * 5
    assert_not @user.valid?
  end
  
end
