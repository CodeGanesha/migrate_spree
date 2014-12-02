## Migrate Spree

This is the code i wrote to migrate our shops from Spree 1.2.4 to rubyclerks. 

It is split into two parts, one part to run in the old spree app, the other to "massage" the data in the new clerks app.

I moved the following classes (only)
- products / variants (with images)
- orders
- users
- taxons / categories

## The Process

In general i tend to have full db backups (yamldb) in development. Not just for backup, also for perfect debugging.
Here it's handy as *m*y transfer was done on *my* machine. Off course you can export on production too.

The end result is a new clerk app with data ready to load in the repository (fixtures or yaml_db)

btw: for non-ascii folks there are unknown and hidden encoding traps for users of 1.8.7. Best to export from 1.9+ . Even 
if production ran under 1.8 (like mine) it should possible to bundle under 1.9 and make life that much easier. Create a branch and destroy your bundle (by upgrading) and do what it takes (view code is not needed!), it is worth it!

Tip: During (the inevitable) development and debugging runs, limit the amount to export/fix for quicker turnaround.

#### Preparation

- Create a new clerk application in the same folder as your old spree app (so their side by side)
- clone this rep next to them
- add this rep to both the spree and clerk gemfile gem "migrate_spree", :path => "../migrate_spree"
- bundle both
- look at the code, if you need more data transferred, go edit

#### Export from spree

- rake db:export:all     will create fixtures into test/fixtures
- move the fixtures into your new clerk app

For the first step you can now decide how to gather products. Initially i did all, but in an old shop that included a lot of old ones, and so the current state is to take everything that has ever been sold. Edit lib/spree/products to change.

#### Load and fix

- rake db:fixtures:load to load the (usually from test/fixtures) (remember to migrate first)
- rake db:fix:all  to get the data more into shape (look at the code, some of it is quite specific. it's mean to be edited.)

Now you can either either use you databases dump tools or yaml_db to save the data. Then you move data and pictures into production and start :-)

## Code Organization

There are two main directories in lib, **clerk* and **spree** which run inside the respective apps. 

The two Rakefiles are *export* and *fix* which run the respective code. Both have a constant that they iterate over with quite dynamic code. 
So it is easy to add another Fix to mould the clerk data more or another Model to export more data from Spree.

There are tasks defined for every step (model/fix) and and "all". So if you need to test order export code, you can run rake db:export:orders.

## Contribute

Obviously, by the time you read this, i have moved on and do not use (read: maintain) this code anymore. Still my hope is that in using this you may feel the urge to improve and contribute for the next guy.

It is basically a public repo, send me a mail and i put you on the team. Just remember to make too specific things configurable.

Copyright (c) 2014 [Torsten], released under the what you want license
