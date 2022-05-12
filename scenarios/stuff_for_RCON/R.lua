-- Optimized stuff for RCON via scenario/mod

-- In order to detect if it's scenario or mod use: /sc if remote.interfaces.R then remote.call("R", "getSource") end
-- If it's a scenario use something like this to get results: /sc someFunction(parameters)
-- If it's a mod use something like this to get results: /sc __R__ someFunction(parameters)
-- You should active the mod by calling "activate()" via rcon, before calling any other fuction.

-- Source: https://github.com/ZwerOxotnik/factorio-RCON-stuff
-- (I should add more stuff)


local is_server = false
local print_to_rcon = rcon.print


remote.add_interface("R", {
	getSource = function()
		print_to_rcon(script.mod_name) -- Returns "level" if it's a scenario, otherwise "R" as a mod.
	end
})

function activate()
	is_server = true
end
function deactivate()
	is_server = false
end


---@param name string
function isPlayerConnected(name)
	if not is_server then return end
	local player = game.get_player(name)
	if player and player.connected then
		print_to_rcon('+')
	else
		print_to_rcon('-')
	end
end

---@param name string
function isPlayerExist(name)
	if not is_server then return end
	if game.get_player(name) then
		print_to_rcon('+')
	else
		print_to_rcon('-')
	end
end

function getForces()
	if not is_server then return end
	local result = {}
	for _, force in pairs(game.forces) do
		result[#result+1] = force.name
	end
	print_to_rcon(game.table_to_json(result))
end

function getPlayers()
	if not is_server then return end
	local result = {}
	for _, player in pairs(game.players) do
		result[#result+1] = player.name
	end
	if #result > 0 then
		print_to_rcon(game.table_to_json(result))
	end
end

function getConnectedPlayers()
	if not is_server then return end
	local result = {}
	for _, player in pairs(game.connected_players) do
		result[#result+1] = player.name
	end
	if #result > 0 then
		print_to_rcon(game.table_to_json(result))
	end
end

function isSomeoneOnServer()
	if not is_server then return end
	if #game.connected_players > 0 then
		print_to_rcon('+')
	else
		print_to_rcon('-')
	end
end


local TwitchMessage = {'R.print_twitch_message', '', ''}
---@param nickname string
---@param message string
function printTwitchMessage(nickname, message)
	TwitchMessage[2] = nickname
	TwitchMessage[3] = message
	game.print(TwitchMessage)
end
