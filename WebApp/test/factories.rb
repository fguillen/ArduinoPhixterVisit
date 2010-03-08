Factory.define :user do |f|
  f.sequence(:email) { |n| "email_#{n}@domain.com" }
  f.password 'pass'
  f.password_confirmation 'pass'
end

Factory.define :phixter do |f|
  f.uri "10.10.10.10:1000"
  f.value "1"
  f.association :user
end

Factory.define :history_event do |f|
  f.association :phixter
end