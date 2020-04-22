 
 _addon.name = 'assist'
_addon.author = 'Darkdoom'
_addon.version = '0.1'
_addon.command = 'as'
_addon.commands = {'start', 'stop', 'help'}
_addon.language = 'english'
 
 

res = require('resources')

running = false
 
 function check_incoming_text(original)
	local org = original:lower()
end
 
 function bpPressNumpad7()    
    
    windower.send_command('setkey numpad7 down; wait 0.3; setkey numpad7 up')

end

function facemob(actor)
    local target = {}
    local self_vector = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().index or 0)
    
    if actor then
        target = actor
        
    else 
        target = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().target_index or 0)
    
    end
    
    if target then

        local angle = (math.atan2((target.y - self_vector.y), (target.x - self_vector.x))*180/math.pi)*-1
		windower.ffxi.turn((angle):radian())
    
    end
    
end
 
 
 function bpEngage()
    

    local player = windower.ffxi.get_player()
    local current_mob = windower.ffxi.get_mob_by_target('bt')
    if current_mob ~= nil then
    
    local current_mob_id = windower.ffxi.get_mob_by_id(current_mob.id)
    local current_mob_hpp = current_mob_id.hpp
    local allowed = S{"WAR", "MNK", "THF", "SAM", "NIN", "BLU", "RNG", "COR", "DRK", "RUN", "PLD", "BST", "PUP", "DNC", "BRD"}
    local current_mob_distance = math.sqrt(current_mob.distance)
 

        if player.status == 0 then

          if allowed[player.main_job] then
          windower.chat.input('/a <bt>')
         
            if current_mob_distance > 2 then
            windower.chat.input('/follow')
            facemob(windower.ffxi.get_mob_by_id(current_mob.id))

            elseif player.status == 0 then
            bpPressNumpad7()
            
            

          end
        end
  .
      elseif player.status == 1 and current_mob_distance < 10 and current_mob_hpp > 1 then
      windower.chat.input('/follow')
     facemob(windower.ffxi.get_mob_by_id(current_mob.id))
      

      end
    end
   end
 
 
  function as_command(...)
	if #arg > 3 then
		windower.add_to_chat(167, 'Invalid command. //assist help for valid options.')
	elseif #arg == 1 and arg[1]:lower() == 'start' then
		if running == false then
			running = true
			windower.add_to_chat(200, 'Assist - START')
		else
			windower.add_to_chat(200, 'Assist is already running.')
		end
	elseif #arg == 1 and arg[1]:lower() == 'stop' then
		if running == true then
			running = false
			windower.add_to_chat(200, 'Assist - STOP')
		else
			windower.add_to_chat(200, 'Assist is not running.')
		end
	elseif #arg == 1 and arg[1]:lower() == 'help' then
		windower.add_to_chat(200, 'Available Options:')
		windower.add_to_chat(200, '  //as start - turns on assist')
		windower.add_to_chat(200, '  //as stop - turns off assist')
	
		windower.add_to_chat(200, '  //as help - displays this text')
	end
end

      windower.register_event('prerender', function()
          if running == true then
            bpEngage()
          end
          end)

windower.register_event('addon command', as_command)
windower.register_event('incoming text', function(new, old)
	local info = windower.ffxi.get_info()
	if not info.logged_in then
		return
	else
		check_incoming_text(new)
	end
end)
