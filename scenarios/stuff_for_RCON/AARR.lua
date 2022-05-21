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
	is_server = true
	-- Active rcon stuff of other interfaces
	for name, interface in pairs(remote.interfaces) do
		if interface["activate_rcon"] then
			remote.call(name, "activate_rcon")
		end
	end
end
function deactivate()
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


local player_info = {
	index = 1,
	afk_time = 0, -- How many ticks since the last action of this player
	online_time = 0,
	last_online = 0,
	ticks_to_respawn = 0,
	display_scale	= 0.0,
	zoom = 0.0,
	health_ratio = 0.0, -- Will also return nil when the player is disconnected
	health = 0.0, -- Will also return nil when the player is disconnected
	admin = false,
	spectator	= false,
	cheat_mode = false,
	in_combat	= false,
	picking_state = false,
	riding_state = false,
	show_on_map	= true,
	minimap_enabled	= true,
	connected	= true,
	is_cursor_empty	= true,
	name = "",
	force_name = "player",
	force_index = 1,
	tag = "",
	surface_name = "",
	surface_index = 1,
	shooting_state = {},
	walking_state = {},
	mining_state = {},
	repair_state = {},
	position = {},
	color = {},
	chat_color = {}
}
-- TODO: add more data
-- https://lua-api.factorio.com/latest/LuaPlayer.html
---@param _player string|integer
function getPlayerInfo(_player)
	if not is_server then return end
	local player = game.get_player(_player)
	if not (player and player.valid) then return end

	player_info.name = player.name
	player_info.force_name = player.force.name
	player_info.force_index = player.force.index
	player_info.tag = player.tag
	player_info.surface_name = player.surface.name
	player_info.surface_index = player.surface.index
	player_info.index = player.index
	player_info.afk_time = player.afk_time
	player_info.online_time = player.online_time
	player_info.last_online = player.last_online
	player_info.ticks_to_respawn = player.ticks_to_respawn
	player_info.display_resolution = player.display_resolution
	player_info.display_scale = player.display_scale
	player_info.zoom = player.zoom
	player_info.admin = player.admin
	player_info.spectator = player.spectator
	player_info.cheat_mode = player.cheat_mode
	player_info.in_combat = player.in_combat
	player_info.picking_state = player.picking_state
	player_info.riding_state = player.riding_state
	player_info.show_on_map = player.show_on_map
	player_info.minimap_enabled = player.minimap_enabled
	player_info.connected = player.connected
	player_info.is_cursor_empty = player.is_cursor_empty()
	player_info.color = player.color
	player_info.chat_color = player.chat_color
	player_info.shooting_state = player.shooting_state
	player_info.walking_state = player.walking_state
	player_info.mining_state = player.mining_state
	player_info.repair_state = player.repair_state
	player_info.position = player.position

	local character = player.character
	if not (character and character.valid) then
		player_info.health = character.health
		player_info.health_ratio = character.get_health_ratio()
	else
		player_info.health_ratio = nil
		player_info.health = nil
	end

	print_to_rcon(game.table_to_json(player_info))
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

---@param name string
function isPlayerAFK(name)
	if not is_server then return end
	local player = game.get_player(name)
	if not (player and player.valid) then return end
	if player.afk_time > 60 * 60 then
		print_to_rcon('+')
	else
		print_to_rcon('-')
	end
end


---@param item_name string
function giveItemStackToPLayer(item_name)
	local player = game.get_player(item_name)
	if not (player and player.valid) then
		print_to_rcon('-')
		return
	end
	if not player.can_insert(item_name) then
		print_to_rcon('-')
		return
	end
	player.insert(item_name)
	print_to_rcon('+')
end


local itemStack = {name=""}
local itemsStack = {name="", count=1}
---@param item_name string
---@param count? integer
function giveItemToPLayer(item_name, count)
	local player = game.get_player(item_name)
	if not (player and player.valid) then
		print_to_rcon('-')
		return
	end

	if count then
		itemsStack.name = item_name
		itemsStack.count = count
		if not player.can_insert(itemsStack) then
			print_to_rcon('-')
			return
		end
		player.insert(itemsStack)
		print_to_rcon('+')
		return
	end

	itemStack.name = item_name
	if not player.can_insert(itemStack) then
		print_to_rcon('-')
		return
	end
	player.insert(itemStack)
	print_to_rcon('+')
end


local force_info = {
	name = "",
	index = 1,
	rockets_launched = 0,
	ghost_time_to_live = 0,
	evolution_factor = 0.0,
	evolution_factor_by_time = 0.0,
	evolution_factor_by_pollution = 0.0,
	evolution_factor_by_killing_spawners = 0.0,
	share_chart = true,
	ai_controllable = false,
	friendly_fire = true,
	research_enabled = true,
	players = {},
	online_players = {},
	offline_players = {},
	researched_technologies = {},
}
-- TODO: add more data
-- https://lua-api.factorio.com/latest/LuaForce.html
---@param force string|integer
function getForceInfo(force)
	local _force = game.forces[force]
	if not (_force and _force.valid) then return end

	force_info.name = _force.name
	force_info.index = _force.index
	force_info.rockets_launched = _force.rockets_launched
	force_info.ghost_time_to_live = _force.ghost_time_to_live
	force_info.evolution_factor = _force.evolution_factor
	force_info.evolution_factor_by_time = _force.evolution_factor_by_time
	force_info.evolution_factor_by_pollution = _force.evolution_factor_by_pollution
	force_info.evolution_factor_by_killing_spawners = _force.evolution_factor_by_killing_spawners
	force_info.share_chart = _force.share_chart
	force_info.ai_controllable = _force.ai_controllable
	force_info.friendly_fire = _force.friendly_fire
	force_info.research_enabled = _force.ai_controllable

	force_info.players = {}
	force_info.online_players = {}
	force_info.offline_players = {}
	for _, player in pairs(_force.players) do
		if player.valid then
			force_info.players[player.index] = player.name
			if player.connected then
				force_info.online_players[player.index] = player.name
			else
				force_info.offline_players[player.index] = player.name
			end
		end
	end

	force_info.researched_technologies = {}
	local researched_technologies = force_info.researched_technologies
	for tech_name in pairs(_force.researched_technologies) do
		researched_technologies[#researched_technologies+1] = tech_name
	end

	print_to_rcon(game.table_to_json(force_info))
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

local surface_info = {
	name = "",
	index = 1,
	ticks_per_day = 1,
	wind_speed = 1.0,
	wind_orientation_change = 1.0, -- Change in wind orientation per tick.
	solar_power_multiplier = 1.0,
	total_pollution = 0.0,
	always_day = false,
	freeze_daytime = false, -- True if daytime is currently frozen.
	peaceful_mode = false,
	players = {},
	online_players = {},
	offline_players = {}
}
-- TODO: add more data
-- https://lua-api.factorio.com/latest/LuaSurface.html
---@param surface string|integer
function getSurfaceInfo(surface)
	if not is_server then return end

	surface = game.surfaces[surface]
	---@cast surface table
	if not (surface and surface.valid) then return end

	surface_info.name = surface.name
	surface_info.index = surface.index
	surface_info.ticks_per_day = surface.ticks_per_day
	surface_info.always_day = surface.always_day
	surface_info.freeze_daytime = surface.freeze_daytime
	surface_info.peaceful_mode = surface.peaceful_mode
	surface_info.wind_speed = surface.wind_speed
	surface_info.wind_orientation_change = surface.wind_orientation_change
	surface_info.solar_power_multiplier = surface.solar_power_multiplier
	surface_info.total_pollution = surface.get_total_pollution()

	surface_info.players = {}
	surface_info.online_players = {}
	surface_info.offline_players = {}
	for _, player in pairs(game.players) do
		if player.valid and player.surface == surface then
			surface_info.players[player.index] = player.name
			if player.connected then
				surface_info.online_players[player.index] = player.name
			else
				surface_info.offline_players[player.index] = player.name
			end
		end
	end

	print_to_rcon(game.table_to_json(surface_info))
end


local game_info = {
	difficulty = 1, -- https://lua-api.factorio.com/latest/defines.html#defines.difficulty
	tick = 0,
	ticks_played = 0, -- The number of ticks since this game was 'created'.
	ticks_to_run = 0, -- The number of ticks to be run while the tick is paused.
	speed = 0.0,
	tick_paused = false,
	players = {},
	online_players = {},
	offline_players = {},
	surfaces = {},
	forces = {}
}
-- TODO: add more data
-- https://lua-api.factorio.com/latest/LuaGameScript.html
function getGameInfo()
	if not is_server then return end

	game_info.difficulty = surface.difficulty
	game_info.tick = surface.tick
	game_info.ticks_played = surface.ticks_played
	game_info.ticks_to_run = surface.ticks_to_run
	game_info.speed = surface.speed
	game_info.tick_paused = surface.tick_paused

	game_info.players = {}
	game_info.online_players = {}
	game_info.offline_players = {}
	for _, player in pairs(surface.players) do
		if player.valid then
			game_info.players[player.index] = player.name
			if player.connected then
				game_info.online_players[player.index] = player.name
			else
				game_info.offline_players[player.index] = player.name
			end
		end
	end

	game_info.surfaces = {}
	for _, surface in pairs(surface.surfaces) do
		if surface.valid then
			game_info.surfaces[surface.index] = surface.name
		end
	end

	game_info.forces = {}
	for _, force in pairs(surface.forces) do
		if force.valid then
			game_info.forces[force.index] = force.name
		end
	end

	print_to_rcon(game.table_to_json(game_info))
end


local TwitchMessage = {'AARR.print_twitch_message', '', ''}
---@param nickname string
---@param message string
function printTwitchMessage(nickname, message)
	TwitchMessage[2] = nickname
	TwitchMessage[3] = message
	game.print(TwitchMessage)
end


local DiscordMessage = {'AARR.print_discord_message', '', ''}
---@param nickname string
---@param message string
function printDiscordMessage(nickname, message)
	DiscordMessage[2] = nickname
	DiscordMessage[3] = message
	game.print(DiscordMessage)
end
