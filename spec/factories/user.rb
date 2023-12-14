FactoryBot.define do
  factory(:user) do
    email { 'example@example.com' }
    password { 'SecretPassword123' }
  end
end
