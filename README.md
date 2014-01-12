ActiveRecord Lite
==================

This was an exercise in recreating rail's activerecord and its basic functionality.

I was able to implement methods such as attr_accessor and attr_accessible through some basic ruby meta programming methods such as define_method and could choose which method to implement at a given time through the ruby send method.

Additionally, this project implemented basic sequel methods using heredocs such as activerecord's find, inject, and update. 

Lastly, this project also implemented activerecord's has_many, has_one_through and  belong_to associations.

