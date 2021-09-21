json.user do |json|
  json.partial! 'users/user', user: @user
end
