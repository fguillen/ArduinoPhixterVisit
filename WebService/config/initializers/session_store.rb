# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_PhixterVisits_session',
  :secret      => '32d50991e2cc836ed5a1d9c24e6b59f386366d6b243667e8c0f71f04c8445bc9f2e23d78801834f60aba50ebcd918a9c5a0674d9505f47f81856596f76d3e59d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
