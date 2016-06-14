# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
tool = Artist.create( name: "Tool" )
karnivool = Artist.create( name: "Karnivool" )

Song.create([
   {title: "Schism", text:"I know the pieces fit cause I watched them fall away.
Mildewed and smoldering. Fundamental differing.
Pure intention juxtaposed will set two lovers souls in motion
Disintegrating as it goes testing our communication
The light that fueled our fire then has burned a hole between us so
We cannot seem to reach an end crippling our communication.", artist: tool},
   {title: "A.M. War", text:"All things aside
We're almost out of time
One more day to see through
Now we've learned that things are not okay
We will all say goodbye
We're almost out of time
In this hopeless cold divide
Something new this time
And I swear it's under my skin", artist: karnivool}
   ])
