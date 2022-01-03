# Couch-pitato: Let there be light...  control the lights, with a raspberry pi, from the couch

## Todo
- Split configuration files for 'prod' and 'dev'
- UI: arrow up/down in button so it's more mobile friendly
- Add default css back for the default live crud pages
- RGB ui polish
- Better ui pages organisation
- Introduce 'scenes' concept
- Have RGB presets saved (to db) and accessible in ui
- Sort UI with groups and group order
- 'fade out' and 'fade in'


## done
- on/off in ui.ex make sure to handle RGB properly. Completely turn all channels on/off
- Create database table for lights and query this for data when needed. Then we can reduce the 'state' to only contain a struct with just RGBW for each channel.
- Seperate lights with only W and RGB. Makes no sense to have RGBW 'lights'. With buttons we can cycle them together (if necesarry).
- Configuration editor (done with default liveview crud! \o/)
- Button editor/configuration
- introduce database setup
- cleanup unused parts (old dmx, artnet, controller and old phoenix ui)
- Start all applications on nerves with Phoenix.PubSub
- Handle input buttons


## Random thoughts
### Design
Have a database table that saves the 'triggers' and 'actions'. Triggers are currently only button presses, but could scale later to other events (sensors, time-based, etc). They will define the action and on what to execute the action. The action are 'atoms' that will have associated code paths with them (for example :onoff is an action that will change the state of a light from on to off, or vice versa).

Action always contain a target (in our case a light atom) to perform the action on. By selecting all the rows with a certain trigger (button associated with GPIO17) we know which action/actions to perform on which targets. It could turn on/off a certain light, but also do multiple actions on multiple lights at once.


### Database
#### Buttons table
button (gpio pin id) - action - light id for action 

#### Lights table
Represents the Light struct we use in code
Todo: tweak and optimise after experimting

name (atom) - ui_name - ui_group_name - ui_group_order - ui_order - default rgbw values - dmx_channel rgbw - rgb (bool)
```

Currently the 'lights' state is in memory. The dmx channel is queried once at startup. The default brightness/rgbw values are queried every request.

