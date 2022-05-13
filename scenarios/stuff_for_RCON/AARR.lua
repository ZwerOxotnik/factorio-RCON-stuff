-- Optimized stuff for RCON via scenario/mod

-- In order to detect if it's scenario or mod use: /sc if remote.interfaces.AARR then remote.call("AARR", "getSource") end
-- If it's a scenario use something like this to get results: /sc someFunction(parameters)
-- If it's a mod use something like this to get results: /sc __AARR__ someFunction(parameters)
-- You should active the mod by calling "activate()" via rcon, before calling any other fuction.

-- Source: https://github.com/ZwerOxotnik/factorio-RCON-stuff
-- (I should add more stuff)


local is_server = false
local print_to_rcon = rcon.print


function activate()
	if is_server then return end
	is_server = true
	-- Active rcon stuff of other interfaces
	for name, interface in pairs(remote.interfaces) do
		if interface["activate_rcon"] then
			remote.call(name, "activate_rcon")
		end
	end
end
function deactivate()
	if not is_server then return end
	is_server = false
	-- Deactive rcon stuff of other interfaces
	for name, interface in pairs(remote.interfaces) do
		if interface["deactivate_rcon"] then
			remote.call(name, "deactivate_rcon")
		end
	end
end
function is_activated()
	if is_server then
		print_to_rcon('+')
	else
		print_to_rcon('-')
	end
end
remote.add_interface("AARR", {
	getSource = function()
		local mod_name = script.mod_name
		print_to_rcon(mod_name) -- Returns "level" if it's a scenario, otherwise "AARR" as a mod.
		return mod_name
	end,
	activate = activate,
	deactivate = deactivate,
	is_activated = is_activated
})



---@param name string
function isPlayerConnected(name)
	if not is_server then return end
	local player = game.get_player(name)
	if player and player.valid and player.connected then
		print_to_rcon('+')
	else
		print_to_rcon('-')
	end
end

---@param name string
function getPlayerIndex(name)
	if not is_server then return end
	local player = game.get_player(name)
	if not (player and player.valid) then return end
	print_to_rcon(player.index)
end

---@param name string
function isPlayerExist(name)
	if not is_server then return end
	local player = game.get_player(name)
	if player and player.valid then
		print_to_rcon('+')
	else
		print_to_rcon('-')
	end
end

function getForces()
	if not is_server then return end
	local result = {}
	for _, force in pairs(game.forces) do
		if force.valid then
			result[#result+1] = force.name
		end
	end
	print_to_rcon(game.table_to_json(result))
end

---@param name string
function getForceIndex(name)
	if not is_server then return end
	local force = game.forces[name]
	if not (force and force.valid) then return end
	print_to_rcon(force.index)
end

function getPlayers()
	if not is_server then return end
	local result = {}
	for _, player in pairs(game.players) do
		if player.valid then
			result[#result+1] = player.name
		end
	end
	if #result > 0 then
		print_to_rcon(game.table_to_json(result))
	end
end

function getConnectedPlayers()
	if not is_server then return end
	local result = {}
	for _, player in pairs(game.connected_players) do
		if player.valid then
			result[#result+1] = player.name
		end
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


local TwitchMessage = {'AARR.print_twitch_message', '', ''}
---@param nickname string
---@param message string
function printTwitchMessage(nickname, message)
	TwitchMessage[2] = nickname
	TwitchMessage[3] = message
	game.print(TwitchMessage)
end
