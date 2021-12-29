# Couch-pitato: Let there be light...  control the lights, with a raspberry pi, from the couch


## Todo
- cleanup unused parts (old dmx, artnet, controller and old phoenix ui)
- introduce database setup
- on/off in ui.ex make sure to handle RGB properly. Completely turn all channels on/off
- web ui: handle on/off for al light with and without rgb
- Configuration editor
- Persist/read configuration
- Sort UI
- Save list buttons and actions
- Button editor/configuration


# done
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

id (atom) - ui_name - ui_group - ui_order - default rgbw values - dmx_channel rgbw - rgb
```
  defstruct ui_name: "no_name",
            ui_group: "no_group",
            ui_order: nil,
            white: true,
            rgb: nil,
            r: 0,
            g: 0,
            b: 0,
            w: 0,
            default_w: 0,
            default_r: 0,
            default_g: 0,
            default_b: 0,
            dmx_channel_w: nil,
            dmx_channel_r: nil,
            dmx_channel_g: nil,
            dmx_channel_b: nil,
            rgbval: nil
end
```

Currently the 'lights' are in memory. Either move it to the database (db call every time) or figure a way to keep states in sync. The current 'rgbw' values should not be peristed to minimize writes.


