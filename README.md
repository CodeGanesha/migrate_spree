Spree Migration
==================

This is the code i wrote to migrate our shops from Spree 1.2.4 to rubyclerks. 

It is split into two parts, one part to run in the old spree app, the other to "massage" the data in the new clerks app.

I moved the followeing classes (only)
- products / variants (with images)
- orders
- users
- taxons / categories

The process
------------

1. Add this gem to your spree app and bundle (actually fork and edit first)
2. rake db:export     will create fixtures into test/fixtures
3. move the fixtures into you new clerk app
4. rake db:fixtures:load to load the (usually from test/fixtures)
5. add this gem to your new clerk app
6. rake db:fix  to get the data more into shape

Actually, before doing the last 2, check the code first. It purges old orders, grabs pictures and does stuff quite
specific to our data. So adapt or just don't


Obviously, by the time you read this, i have moved on and do not use (read: maintain) this code anymore. Still my hope is that in using this you may feel the urge to improve and contribute for the next guy.


Usage
=======

Copyright (c) 2014 [Torsten], released under the what you want license
