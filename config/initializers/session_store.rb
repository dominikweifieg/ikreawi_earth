# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_earth_session',
  :secret      => 'a2c3091f963d4db2dece2693dac613ba5f2c0d6618eb953c92094d8ce135303a54b71e4395e452b53c296185c299c7164f8851a588443e4182aaa02bcae8fa8b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
