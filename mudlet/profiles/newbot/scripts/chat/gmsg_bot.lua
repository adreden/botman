--[[
    Botman - A collection of scripts for managing 7 Days to Die servers
    Copyright (C) 2017  Matthew Dwyer
	           This copyright applies to the Lua source code in this Mudlet profile.
    Email     mdwyer@snap.net.nz
    URL       http://botman.nz
    Source    https://bitbucket.org/mhdwyer/botman
--]]

local tmp, debug, pname, pid, result
local shortHelp = false
local skipHelp = false

debug = false -- should be false unless testing

if botman.debugAll then
	debug = true
end

function gmsg_bot()
	calledFunction = "gmsg_bot"
	result = false

-- ################## Bot command functions ##################

	local function cmd_ResetBot()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "reset") or string.find(chatvars.command, "bot"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "reset bot")
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "reset bot keep money")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Tell the bot to forget only some things, some player info, locations, bases etc.  You will be asked to confirm this, answer with yes.  Say anything else to abort.")
					irc_chat(chatvars.ircAlias, "Use this command after wiping the server.  The bot will detect the day change and will ask if you want to reset the bot too.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "reset" and chatvars.words[2] == "bot" and chatvars.words[3] == "keep" and (chatvars.words[4] == "money" or chatvars.words[4] == "cash" or chatvars.words[4] == server.moneyName or chatvars.words[4] == server.moneyPlural) then
			if chatvars.accessLevel > 0 then
				message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
				botman.faultyChat = false
				return true
			end

			message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]Are you sure you want to reset me?  Answer yes to proceed or anything else to cancel.[-]")
			players[chatvars.playerid].botQuestion = "reset bot keep money"

			botman.faultyChat = false
			return true
		end

		if (chatvars.words[1] == "reset") and (chatvars.words[2] == "bot") and (chatvars.playerid ~= 0) then
			if chatvars.accessLevel > 0 then
				message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
				botman.faultyChat = false
				return true
			end

			message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]Are you sure you want to reset me?  Answer yes to proceed or anything else to cancel.[-]")
			players[chatvars.playerid].botQuestion = "reset bot"

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_QuickResetBot()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "reset") or string.find(chatvars.command, "bot"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "quick reset bot")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Tell the bot to forget only some things, some player info, locations, bases etc.  You will be asked to confirm this, answer with yes.  Say anything else to abort.")
					irc_chat(chatvars.ircAlias, "Use this command after wiping the server.  The bot will detect the day change and will ask if you want to reset the bot too.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "quick") and (chatvars.words[2] == "reset") and (chatvars.words[3] == "bot") then
			if chatvars.accessLevel > 0 then
				message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
				botman.faultyChat = false
				return true
			end

			message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]Are you sure you want to reset me?  Answer yes to proceed or anything else to cancel.[-]")
			players[chatvars.playerid].botQuestion = "quick reset bot"

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_RestoreBackup()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "restore") or string.find(chatvars.command, "backup"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "restore backup")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "The bot saves its Lua tables daily at midnight (server time) and each time the server is shut down.")
					irc_chat(chatvars.ircAlias, "If the bot gets messed up, you can try to fix it with this command. Other timestamped backups are made before the bot is reset but you will first need to strip the date part off them to restore with this command.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "restore" and (chatvars.words[2] == "backup" or chatvars.words[2] == "bot") and chatvars.words[3] == nil then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 1) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 1) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			importLuaData()

			if (chatvars.playername ~= "Server") then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The backup has been restored.[-]")
			else
				irc_chat(chatvars.ircAlias, "The backup has been restored.")
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetBotAlertColour()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "alert") or string.find(chatvars.command, "colo"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set alert colour {hex code>")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Set the colour of server alert messages.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "alert" and string.find(chatvars.words[3], "colo") then
			if chatvars.words[4] == nil then
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]Please specify a colour code. eg. FF0000[-]")
				else
					irc_chat(chatvars.ircAlias, "Please specify a colour code. eg. FF0000")
				end

				botman.faultyChat = false
				return true
			end

			server.alertColour = string.upper(chatvars.words[4])

			-- strip out any # characters
			server.alertColour = server.alertColour:gsub("#", "")
			server.alertColour = string.sub(server.alertColour, 1, 6)

			conn:execute("UPDATE server SET alertColour = '" .. escape(server.alertColour) .. "'")

			if (chatvars.playername ~= "Server") then
				message("pm " .. chatvars.playerid .. " [" .. server.alertColour .. "]You have changed the colour for alert messages from the bot.[-]")
			else
				irc_chat(chatvars.ircAlias, "You have changed the colour for alert messages from the bot.")
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetBotName()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, " name") or string.find(chatvars.command, " bot"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "name bot {some cool name}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "The default name is Bot.  Help give your bot a personality by giving it a name.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "name" and chatvars.words[2] == "bot" and chatvars.words[3] ~= nil) then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 0) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 0) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			tmp = stripQuotes(string.sub(chatvars.oldLine, string.find(chatvars.oldLine, chatvars.words[2], nil, true) + 4, string.len(chatvars.oldLine)))
			if tmp == "Tester" and chatvars.playerid ~= Smegz0r then
				message("say [" .. server.warnColour .. "]That name is reserved.[-]")
				botman.faultyChat = false
				return true
			end

			server.botName = tmp
			message("say [" .. server.chatColour .. "]I shall henceforth be known as " .. server.botName .. ".[-]")

			msg = "say [" .. server.chatColour .. "]Hello I am the server bot, " .. server.botName .. ". Pleased to meet you. :3[-]"
			tempTimer( 5, [[message(msg)]] )

			conn:execute("UPDATE server SET botName = '" .. escape(server.botName) .. "'")

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetBotChatColour()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "chat") or string.find(chatvars.command, "colo"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set chat colour {hex code}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Set the colour of server messages.  Player chat will be the default colour.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "chat" and string.find(chatvars.words[3], "colo") then
			if chatvars.words[4] == nil then
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]Please specify a colour code. eg. FF0000[-]")
				else
					irc_chat(chatvars.ircAlias, "Please specify a colour code. eg. FF0000")
				end

				botman.faultyChat = false
				return true
			end

			server.chatColour = string.upper(chatvars.words[4])

			-- strip out any # characters
			server.chatColour = server.chatColour:gsub("#", "")
			server.chatColour = string.sub(server.chatColour, 1, 6)

			conn:execute("UPDATE server SET chatColour = '" .. escape(server.chatColour) .. "'")

			if (chatvars.playername ~= "Server") then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]You have changed the bot's chat colour.[-]")
			else
				irc_chat(chatvars.ircAlias, "You have changed the bot's chat colour.")
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetBotWarningColour()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "warn") or string.find(chatvars.command, "colo"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set warn colour {hex code}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Set the colour of server warning messages.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "warn" and string.find(chatvars.words[3], "colo") then
			if chatvars.words[4] == nil then
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]Please specify a colour code. eg. FF0000[-]")
				else
					irc_chat(chatvars.ircAlias, "Please specify a colour code. eg. FF0000")
				end

				botman.faultyChat = false
				return true
			end

			server.warnColour = string.upper(chatvars.words[4])

			-- strip out any # characters
			server.warnColour = server.warnColour:gsub("#", "")
			server.warnColour = string.sub(server.warnColour, 1, 6)

			conn:execute("UPDATE server SET warnColour = '" .. escape(server.warnColour) .. "'")

			if (chatvars.playername ~= "Server") then
				message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]You have changed the colour for warning messages from the bot.[-]")
			else
				irc_chat(chatvars.ircAlias, "You have changed the colour for warning messages from the bot.")
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetUpdateBranch()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "upd") or string.find(chatvars.command, "set") or string.find(chatvars.command, "branch"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set update branch")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Bot updates are released in two branches, stable and testing.  The stable branch will not update as often and should have less issues than testing.")
					irc_chat(chatvars.ircAlias, "New and trial features will release to testing before stable. Important fixes will be ported to stable from testing whenever possible.")
					irc_chat(chatvars.ircAlias, "You can switch between branches as often as you want.  Any changes in testing that are not in stable will never break stable should you switch back to it.")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "update" and chatvars.words[3] == "branch" then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 2) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 2) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			if chatvars.words[4] ~= "" then
				server.updateBranch = chatvars.words[4]
				conn:execute("UPDATE server set updateBranch = '" .. chatvars.words[4] .. "'")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The bot will check for updates from the " .. chatvars.words[4] .. " branch.[-]")
				else
					irc_chat(chatvars.ircAlias, "The bot will check for updates from the " .. chatvars.words[4] .. " branch.")
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ToggleBotRestart()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "bot") or string.find(chatvars.command, "start") or string.find(chatvars.command, "able"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "enable/disable bot restart")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Using a launcher script or some other monitoring process you can have the bot automatically restart itself every time it terminates.")
					irc_chat(chatvars.ircAlias, "Periodically restarting the bot helps to keep it running at its best.")
					irc_chat(chatvars.ircAlias, "This feature is disabled by default.  A restart script can be downloaded from http://botman.nz/shellscripts.zip")
					irc_chat(chatvars.ircAlias, "You will need to inspect and modify some paths in the scripts to match your setup.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if string.find(chatvars.command, "able") and chatvars.words[2] == "bot" and string.find(chatvars.command, "restart") then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 0) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 0) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			if chatvars.words[1] == "enable" then
				server.allowBotRestarts = true
				conn:execute("UPDATE server SET allowBotRestarts = 1")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]You will be able to restart the bot with the command " .. server.commandPrefix .. "restart bot.[-]")
				else
					irc_chat(chatvars.ircAlias, "You will be able to restart the bot with the command " .. server.commandPrefix .. "restart bot.")
				end
			else
				server.allowBotRestarts = false
				conn:execute("UPDATE server SET allowBotRestarts = 0")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The command " .. server.commandPrefix .. "restart bot, will not do anything.[-]")
				else
					irc_chat(chatvars.ircAlias, "The command " .. server.commandPrefix .. "restart bot, will not do anything.")
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetMasterPassword()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "pass") or string.find(chatvars.command, "set"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set master password {secret password up to 50 characters}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Protect important commands such as " .. server.commandPrefix .. "reset bot with a password.")
					irc_chat(chatvars.ircAlias, "This will prevent you or another server owner from accidentally doing something stupid (hopefully).")
					irc_chat(chatvars.ircAlias, "To remove it use " .. server.commandPrefix .. "clear master password.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "set" or chatvars.words[1] == "clear") and chatvars.words[2] == "master" and chatvars.words[3] == "password" then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 0) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 0) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			if chatvars.words[1] == "clear" then
				server.masterPassword = ""
				conn:execute("UPDATE server SET masterPassword = ''")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]You have cleared the master password. Bot commands are only protected by access levels.[-]")
				else
					irc_chat(chatvars.ircAlias, "You have cleared the master password. Bot commands are only protected by access levels.")
				end
			else
				server.masterPassword = string.sub(chatvars.command, string.find(chatvars.command, "master password") + 16)
				conn:execute("UPDATE server SET masterPassword = '" .. escape(server.masterPassword) .. "'")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]You have set a password to protect important bot commands.[-]")
				else
					irc_chat(chatvars.ircAlias, "You have set a password to protect important bot commands.")
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_UpdateCode()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "update") or string.find(chatvars.command, "code") or string.find(chatvars.command, "script"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "update code")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Make the bot check for script updates.  They will be installed if you have set " .. server.commandPrefix .. "enable updates")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "update" and (chatvars.words[2] == "code" or chatvars.words[2] == "scripts" or words[2] == "bot") and chatvars.words[3] == nil then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 2) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				-- allow from irc
			end

			updateBot(true, chatvars.playerid)

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_RefreshCode()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "refresh") or string.find(chatvars.command, "code") or string.find(chatvars.command, "script"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "update code")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Make the bot re-download and install from the current code branch for script updates.  Only necessary if someone has edited the code and needs to restore it.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "refresh" and (chatvars.words[2] == "code" or chatvars.words[2] == "scripts" or words[2] == "bot") and chatvars.words[3] == nil then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 2) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				-- allow from irc
			end

			botman.refreshCode = true
			updateBot(true, chatvars.playerid)

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ToggleBotUpdates()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "able") or string.find(chatvars.command, "upd"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "enable/disable updates (disabled by default)")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Allow the bot to automatically update itself by downloading scripts. It will check daily, but you can also command it to check immediately with " .. server.commandPrefix .. "update bot")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "enable" or chatvars.words[1] == "disable") and chatvars.words[2] == "updates" and chatvars.words[3] == nil then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 2) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 2) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			if chatvars.words[1] == "enable" then
				server.updateBot = true
				conn:execute("UPDATE server set updateBot = 1")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The bot will automatically update itself daily if newer scripts are available.[-]")
				else
					irc_chat(chatvars.ircAlias, "The bot will automatically update itself daily if newer scripts are available.")
				end
			else
				server.updateBot = false
				conn:execute("UPDATE server set updateBot = 0")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The bot will not update automatically.  You will see an alert on IRC if an update is available.[-]")
				else
					irc_chat(chatvars.ircAlias, "The bot will not update automatically.  You will see an alert on IRC if an update is available.")
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ClearBotsWhitelist()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "white"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "clear whitelist")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Remove everyone from the bot's whitelist.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "clear" and chatvars.words[2] == "whitelist" and chatvars.words[3] == nil then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 1) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 1) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			conn:execute("TRUNCATE TABLE whitelist")

			if (chatvars.playername ~= "Server") then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The whitelist has been cleared.[-]")
			else
				irc_chat(chatvars.ircAlias, "The whitelist has been cleared.")
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_WhitelistEveryone()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "white"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "whitelist all")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "You can add everyone except blacklisted players to the bot's whitelist.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "whitelist" and (chatvars.words[2] == "everyone" or chatvars.words[2] == "all") then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 1) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 1) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			for k,v in pairs(players) do
				if not string.find(server.blacklistCountries, v.country) then
					conn:execute("INSERT INTO whitelist (steam) VALUES (" .. k .. ")")
				end
			end

			if (chatvars.playername ~= "Server") then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Everyone except blacklisted players has been whitelisted.[-]")
			else
				irc_chat(chatvars.ircAlias, "Everyone except blacklisted players has been whitelisted.")
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetBlacklistResponse()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "black") or string.find(chatvars.command, " ban"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "blacklist action ban (or exile or 'nothing')")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Set what happens to blacklisted players.  The default is to ban them 10 years but if you create a location called exile, the bot can bannish them to there instead.  It acts like a prison.")
					irc_chat(chatvars.ircAlias, "To disable the blacklist, set action to the word nothing.")
					irc_chat(chatvars.ircAlias, "NOTE: If blacklist action is nothing, proxies won't trigger a ban or exile response either.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "blacklist" and string.find(chatvars.words[2], "action") then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 0) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 0) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			if chatvars.words[3] == nil then
				chatvars.words[3] = "nothing"
			end

			if chatvars.words[3] ~= "exile" and chatvars.words[3] ~= "ban" and chatvars.words[3] ~= "nothing" then
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]Expected ban, exile or nothing as 3rd word.[-]")
				else
					irc_chat(chatvars.ircAlias, "Expected ban, exile or nothing as 3rd word.")
				end

				botman.faultyChat = false
				return true
			end

			server.blacklistResponse = chatvars.words[3]
			conn:execute("UPDATE server SET blacklistResponse  = '" .. escape(chatvars.words[3]) .. "'")

			if chatvars.words[3] == "ban" then
				response = "Blacklisted players will be banned."
			end

			if chatvars.words[3] == "exile" then
				response = "Blacklisted players will be exiled if a location called exile exists."
			end

			if chatvars.words[3] == "nothing" then
				response = "Nothing will happen to blacklisted players. The blacklist is disabled."
			end

			if (chatvars.playername ~= "Server") then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]" .. response .. "[-]")
			else
				irc_chat(chatvars.ircAlias, response)
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_NoReset()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "reset"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "no reset")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "If the bot detects that the server days have rolled back, it will ask you if you want to reset the bot.  Type " .. server.commandPrefix .. "no reset if you don't want the bot to reset itself.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "no") and (chatvars.words[2] == "reset") then
			if chatvars.accessLevel > 0 then
				message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
				botman.faultyChat = false
				return true
			end

			message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Oh ok then.[-]")
			server.warnBotReset = false

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ResetServer()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "reset") or string.find(chatvars.command, "server"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "reset server")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Tell the bot to forget everything it knows about the server.  You will be asked to confirm this, answer with yes.  Say anything else to abort.")
					irc_chat(chatvars.ircAlias, "Usually you only need to use " .. server.commandPrefix .. "reset bot.  This reset goes further.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "reset") and (chatvars.words[2] == "server") then
			if chatvars.accessLevel > 0 then
				message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
				botman.faultyChat = false
				return true
			end

			message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]Are you sure you want to wipe me completely clean?  Answer yes to proceed or anything else to cancel.[-]")
			players[chatvars.playerid].botQuestion = "reset server"

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ToggleLagCheck()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "able") or string.find(chatvars.command, "lag"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "enable/disable lag check (enabled by default)")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Every 10 seconds while connected to the server, the bot sends a special lag check command to the server and times the response.")
					irc_chat(chatvars.ircAlias, "If the bot detects more than 10 seconds delay, it will automatically suspend several bot functions to reduce the number of commands that it sends to the server.")
					irc_chat(chatvars.ircAlias, "You can disable this check, but your bot won't pause for lag and the server could get significantly behind during busy times.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "enable" or chatvars.words[1] == "disable") and chatvars.words[2] == "lag" then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 2) then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]" .. restrictedCommandMessage() .. "[-]")
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 2) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			if chatvars.words[1] == "enable" then
				server.enableLagCheck = true
				conn:execute("UPDATE server set enableLagCheck = 1")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The bot will test for command lag and will suspend some bot functions when necessary.[-]")
				else
					irc_chat(chatvars.ircAlias, "The bot will test for command lag and will suspend some bot functions when necessary.")
				end
			else
				server.enableLagCheck = false
				conn:execute("UPDATE server set enableLagCheck = 0")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The bot will not test for command lag. Server commands may be delayed during busy times.[-]")
				else
					irc_chat(chatvars.ircAlias, "The bot will not test for command lag. Server commands may be delayed during busy times.")
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_GuessPassword()
		if (chatvars.words[1] == "password") and (chatvars.words[2] ~= nil) and (chatvars.accessLevel < 3) then
			local response

			if chatvars.ircid ~= 0 then
				id = chatvars.ircid
			else
				id = chatvars.playerid
			end

			if string.sub(chatvars.command, string.find(chatvars.command, "password") + 9) ~= server.masterPassword then
				response = "password attempt failed."

				r = rand(10)
				if (r == 1) then response = "Your weak " .. response end
				if (r == 2) then response = "That pathetic " .. response end
				if (r == 3) then response = "Oh please. " .. firstToUpper(response) end
				if (r == 4) then response = "So close! " .. firstToUpper(response) end
				if (r == 5) then response = "Stop guessing. " .. firstToUpper(response) end
				if (r == 6) then response = "Uh uh uh! You forgot to say the magic word."end
				if (r == 7) then response = "Stop it! " .. firstToUpper(response) end
				if (r == 8) then response = "BZZT! " .. firstToUpper(response) end
				if (r == 9) then response = "Ruh roh! " .. firstToUpper(response) end
				if (r == 10) then response = "That's the wrongest password I've ever seen!" end

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]" .. response .. "[-]")
				else
					irc_chat(chatvars.ircAlias, response)
				end

				botman.faultyChat = false
				return true
			else
				-- password accepted (or a great guess)
				if players[id].botQuestion == "reset server" and chatvars.accessLevel == 0 then
					ResetServer()

					botman.faultyChat = false
					return true
				end

				 if players[id].botQuestion == "restart bot" and (chatvars.accessLevel < 3) then
					players[id].botQuestion = ""
					players[id].botQuestionID = nil
					players[id].botQuestionValue = nil

					restartBot()

					botman.faultyChat = false
					return true
				end

				if players[ID].botQuestion == "reset bot keep money" and chatvars.accessLevel == 0 then
					ResetBot(true)

					message("say [" .. server.chatColour .. "]The bot has been reset.  All bases, inventories etc are forgotten, but not the players or their money.[-]")

					players[id].botQuestion = ""
					players[id].botQuestionID = nil
					players[id].botQuestionValue = nil

					botman.faultyChat = false
					return true
				end

				if players[id].botQuestion == "reset bot" and chatvars.accessLevel == 0 then
					ResetBot()

					message("say [" .. server.chatColour .. "]The bot has been reset.  All bases, inventories etc are forgotten, but not the players.[-]")

					players[id].botQuestion = ""
					players[id].botQuestionID = nil
					players[id].botQuestionValue = nil

					botman.faultyChat = false
					return true
				end

				if players[id].botQuestion == "quick reset bot" and chatvars.accessLevel == 0 then
					QuickBotReset()

					message("say [" .. server.chatColour .. "]The bot has been reset except for players, locations and reset zones.[-]")

					players[id].botQuestion = ""
					players[id].botQuestionID = nil
					players[id].botQuestionValue = nil

					botman.faultyChat = false
					return true
				end
			end

			players[id].botQuestion = ""
			players[id].botQuestionID = nil
			players[id].botQuestionValue = nil

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_RestartBot()
		if (chatvars.words[1] == "restart") and (chatvars.words[2] == "bot") and (chatvars.accessLevel < 3) then
			if not server.allowBotRestarts then
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]This command is disabled.  Enable it with /enable bot restart[-]")
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]If you do not have a script or other process monitoring the bot, it will not restart automatically.[-]")
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Scripts can be downloaded at http://botman.nz/shellscripts.zip and may require some editing for paths.[-]")
				else
					irc_chat(chatvars.ircAlias, "This command is disabled.  Enable it with /enable bot restart")
					irc_chat(chatvars.ircAlias, "If you do not have a script or other process monitoring the bot, it will not restart automatically.")
					irc_chat(chatvars.ircAlias, "Scripts can be downloaded at http://botman.nz/shellscripts.zip and may require some editing for paths.")
				end

				botman.faultyChat = false
				return true
			end

			if botman.customMudlet then
				if server.masterPassword ~= "" then
					if (chatvars.playername ~= "Server") then
						message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]This command requires a password to complete. Don't use this command unless you know what it does and why you need to do it.[-]")
						message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]Type " .. server.commandPrefix .. "password {the password} (Do not type the {}).[-]")
						players[chatvars.playerid].botQuestion = "restart bot"
					else
						irc_chat(chatvars.ircAlias, "This command requires a password to complete. Don't use this command unless you know what it does and why you need to do it.")
						irc_chat(chatvars.ircAlias, "Type " .. server.commandPrefix .. "password {the password} (Do not type the {}).")
						players[chatvars.ircid].botQuestion = "restart bot"
					end
				else
					restartBot()
				end
			else
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]This command is not supported in your Mudlet.  You need the latest custom Mudlet by TheFae or Mudlet 3.4[-]")
				else
					irc_chat(chatvars.ircAlias, "This command is not supported in your Mudlet.  You need the latest custom Mudlet by TheFae or Mudlet 3.4")
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ReloadBot()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and string.find(chatvars.command, "reload bot")) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "reload bot")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Make the bot read several things from the server including admin list, ban list, gg, lkp and others.  If you have Coppi's Mod installed it will also detect that.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "reload" or chatvars.words[1] == "refresh" or chatvars.words[1] == "update") and chatvars.words[2] == "bot" then
			-- run admin list, gg, ban list and lkp

			if (chatvars.playername ~= "Server") then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Refreshing admins, bans, server config from server.[-]")
			else
				irc_chat(chatvars.ircAlias, "Refreshing admins, bans, server config from server.")
			end

			send("lkp -online")

			if botman.getMetrics then
				metrics.telnetCommands = metrics.telnetCommands + 1
			end

			if botman.getMetrics then
				metrics.telnetCommands = metrics.telnetCommands + 1
			end

			--tempTimer( 4, [[message("say [" .. server.chatColour .. "]Reading admin list[-]")]] )
			tempTimer( 4, [[send("admin list")]] )

			--tempTimer( 6, [[message("say [" .. server.chatColour .. "]Reading bans[-]")]] )
			tempTimer( 6, [[send("ban list")]] )

			--tempTimer( 8, [[message("say [" .. server.chatColour .. "]Reading server config[-]")]] )
			tempTimer( 8, [[send("gg")]] )

			--tempTimer( 10, [[message("say [" .. server.chatColour .. "]Reading claims[-]")]])
			tempTimer( 10, [[send("llp)]] )

			tempTimer( 13, [[send("pm IPCHECK")]] )
			--tempTimer( 13, [[message("say [" .. server.chatColour .. "]Reload complete.[-]")]] )

			tempTimer( 15, [[send("teleh")]] )
			tempTimer( 20, [[registerBot()]] )

			if botman.getMetrics then
				metrics.telnetCommands = metrics.telnetCommands + 6
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_RejoinIRC()
		if chatvars.showHelp and not skipHelp then
			if string.find(chatvars.command, "irc") or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "rejoin irc")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Sometimes the bot can fall off IRC and fail to reconnect.  This command forces it to reconnect.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "rejoin" or chatvars.words[1] == "reconnect") and chatvars.words[2] == "irc" then
			-- join (or rejoin) the irc server incase the bot has fallen off and failed to reconnect
			if botman.customMudlet then
				joinIRCServer()
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetBotRestartDay()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "restart") or string.find(chatvars.command, " bot")  or string.find(chatvars.command, " set"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set bot restart {0+} (total bot days running)")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "The bot can automatically restart itself after running for days. The restart helps fix issues and keeps the bot fresh.")
					irc_chat(chatvars.ircAlias, "The default is 7 days between bot restarts. You can disable it by setting it to 0. Also it will only activate if bot restarts are enabled.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "set") and (chatvars.words[2] == "bot") and (chatvars.words[3] == "restart") and (chatvars.accessLevel < 3) then
			if chatvars.number == nil then
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]A number of 0 or more is required.[-]")
				else
					irc_chat(chatvars.ircAlias, "A number of 0 or more is required.")
				end

				botman.faultyChat = false
				return true
			end

			chatvars.number = math.abs(chatvars.number)
			server.botRestartDay = chatvars.number
			if botman.dbConnected then conn:execute("UPDATE server SET botRestartDay = " .. server.botRestartDay) end

			if server.botRestartDay > 0 then
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The bot will quit and automatically restart after running for " .. server.botRestartDay .. " days.[-]")
				else
					irc_chat(chatvars.ircAlias, "The bot will quit and automatically restart after running for " .. server.botRestartDay .. " days.")
				end
			else
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The bot will run until manually stopped.[-]")
				else
					irc_chat(chatvars.ircAlias, "The bot will run until manually stopped.")
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ShutdownBot()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "shut") or string.find(chatvars.command, "stop") or string.find(chatvars.command, "bot"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "shutdown bot")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "While not essential as it seems to work just fine, you can tell the bot to save all pending player data, before you quit Mudlet.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "shutdown" and chatvars.words[2] == "bot") then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 0) then
					message(string.format("pm %s [%s]" .. restrictedCommandMessage(), chatvars.playerid, server.chatColour))
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 0) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			irc_chat(server.ircMain, "Saving player data.  Wait a minute before stopping Mudlet or until I say I'm ready.")

			if (chatvars.playername ~= "Server") then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Saving player data.  Wait a minute before stopping Mudlet or until I say I'm ready.[-]")
				shutdownBot(chatvars.playerid)
			else
				tempTimer( 3, [[shutdownBot(0)]] ) -- This timer is necessary to stop Mudlet freezing.  It doesn't seem to like running this function as server immediately but is fine with a delay.
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetCommandPrefix()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "prefix"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set command prefix / (or no symbol or any symbol except \\")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Change bot commands from using / to using nothing or another symbol.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "set" and chatvars.words[2] == "command" and chatvars.words[3] == "prefix") then
			tmp.prefix = chatvars.words[4]

			if tmp.prefix == "\\" then
				irc_chat(server.ircMain, "The bot does not support commands using a \\ because it is a special character in Lua and will not display in chat.  Please choose another symbol.")
				return
			end

			if tmp.prefix ~= "" then
				server.commandPrefix = tmp.prefix
				conn:execute("UPDATE server SET commandPrefix = '" .. tmp.prefix .. "'")

				if (chatvars.playername ~= "Server") then
					message("say [" .. server.chatColour .. "]Commands now begin with a " .. server.commandPrefix .. ". To use commands such as who type " .. server.commandPrefix .. "who.[-]")
				else
					irc_chat(server.ircMain, "Ingame bot commands must now start with a " .. tmp.prefix)
				end

				send("tcch " .. tmp.prefix)

				if botman.getMetrics then
					metrics.telnetCommands = metrics.telnetCommands + 1
				end
			else
				server.commandPrefix = ""
				conn:execute("UPDATE server SET commandPrefix = ''")

				if (chatvars.playername ~= "Server") then
					message("say [" .. server.chatColour .. "]Bot commands are now just text.  To use commands such as who simply type who.[-]")
				else
					irc_chat(server.ircMain, "Ingame bot commands do not use a prefix such as /  Instead just type the commands as words.")
				end

				send("tcch")

				if botman.getMetrics then
					metrics.telnetCommands = metrics.telnetCommands + 1
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ApproveGlobalBan()
		if chatvars.words[1] == "approve" and chatvars.words[2] == "gblban" and chatvars.words[3] ~= nil then
			if (chatvars.playerid ~= "Server") then
				if (chatvars.playerid ~= Smegz0r and chatvars.ircid ~= Smegz0r) then
					message(string.format("pm %s [%s]This command can only be used by Smegz0r. Get your own :P", chatvars.playerid, server.chatColour))
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.playerid ~= Smegz0r and chatvars.ircid ~= Smegz0r) then
					irc_chat(chatvars.ircAlias, "This command can only be used by Smegz0r. Get your own :P")
					botman.faultyChat = false
					return true
				end
			end

			pname = string.sub(chatvars.command, string.find(chatvars.command, "gblban ") + 7)
			pname = string.trim(pname)
			id = LookupPlayer(pname)

			if id ~= 0 then
				-- don't ban if player is an admin :O
				if accessLevel(id) < 3 then
					if (chatvars.playername ~= "Server") then
						message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]You what?  You want to global ban one of the admins?   [DENIED][-]")
					else
						irc_chat(chatvars.ircAlias, "You what?  You want to global ban one of the admins?   [DENIED]")
					end

					botman.faultyChat = false
					return true
				end
			else
				-- pname must be a steam id
				id = pname
			end

			connBots:execute("UPDATE bans set GBLBan = 1, GBLBanVetted = 1, GBLBanActive = 1 WHERE steam = " .. id)

			if (chatvars.playername ~= "Server") then
				if players[id] then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]" .. players[id].name .. "'s global ban has been approved.[-]")
				else
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]" .. pname .. "'s global ban has been approved.[-]")
				end
			else
				if players[id] then
					irc_chat(chatvars.ircAlias, players[id].name .. "'s global ban has been approved.")
				else
					irc_chat(chatvars.ircAlias, pname .. "'s global ban has been approved.")
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ToggleHackerTPDetection()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "hack") or string.find(chatvars.command, "tele") or string.find(chatvars.command, "able"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "disable hacker tp detection")
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "enable hacker tp detection")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Some mods or managers don't report legit teleports to telnet which breaks the bot's hacker teleport detection.")
					irc_chat(chatvars.ircAlias, "If the bot doesn't automatically disable/enable hacker tp detection, you can manually change it.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "disable" or chatvars.words[1] == "enable") and chatvars.words[2] == "hacker" then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 0) then
					message(string.format("pm %s [%s]" .. restrictedCommandMessage(), chatvars.playerid, server.chatColour))
					botman.faultyChat = false
					return true
				end
			else
				if (chatvars.accessLevel > 0) then
					irc_chat(chatvars.ircAlias, "This command is restricted.")
					botman.faultyChat = false
					return true
				end
			end

			if chatvars.words[1] == "disable" then
				server.hackerTPDetection = false
				if botman.dbConnected then conn:execute("UPDATE server SET hackerTPDetection = 0") end

				if (chatvars.playername ~= "Server") then
					message(string.format("pm %s [%s]Hacker teleport detection is disabled.", chatvars.playerid, server.chatColour))
				else
					irc_chat(chatvars.ircAlias, "Hacker teleport detection is disabled.")
				end
			end

			if chatvars.words[1] == "enable" then
				server.hackerTPDetection = true
				if botman.dbConnected then conn:execute("UPDATE server SET hackerTPDetection = 1") end

				if (chatvars.playername ~= "Server") then
					message(string.format("pm %s [%s]Hacker teleport detection is enabled.", chatvars.playerid, server.chatColour))
				else
					irc_chat(chatvars.ircAlias, "Hacker teleport detection is enabled.")
				end
			end

			botman.faultyChat = false
			return true
		end
	end

-- ################## End of command functions ##################

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	-- don't proceed if there is no leading slash
	if (string.sub(chatvars.command, 1, 1) ~= server.commandPrefix and server.commandPrefix ~= "") then
		botman.faultyChat = false
		return false
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	if chatvars.showHelp then
		if chatvars.words[3] then
			if not string.find(chatvars.words[3], "bot") then
				skipHelp = true
			end
		end

		if chatvars.words[1] == "help" then
			skipHelp = false
		end

		if chatvars.words[1] == "list" then
			shortHelp = true
		end
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	if chatvars.showHelp and not skipHelp and chatvars.words[1] ~= "help" then
		irc_chat(chatvars.ircAlias, ".")
		irc_chat(chatvars.ircAlias, "Bot Commands:")
		irc_chat(chatvars.ircAlias, "=============")
		irc_chat(chatvars.ircAlias, ".")
		irc_chat(chatvars.ircAlias, "These commands are for bot specific settings.")
		irc_chat(chatvars.ircAlias, ".")
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	if chatvars.showHelpSections then
		irc_chat(chatvars.ircAlias, "bot")
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_ApproveGlobalBan()

	if result then
		if debug then dbug("debug cmd_ApproveGlobalBan triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_ClearBotsWhitelist()

	if result then
		if debug then dbug("debug cmd_ClearBotsWhitelist triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_GuessPassword()

	if result then
		if debug then dbug("debug cmd_GuessPassword triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_QuickResetBot()

	if result then
		if debug then dbug("debug cmd_QuickResetBot triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_RejoinIRC()

	if result then
		if debug then dbug("debug cmd_RejoinIRC triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_ReloadBot()

	if result then
		if debug then dbug("debug cmd_ReloadBot triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_ResetBot()

	if result then
		if debug then dbug("debug cmd_ResetBot triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_RestartBot()

	if result then
		if debug then dbug("debug cmd_RestartBot triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_RestoreBackup()

	if result then
		if debug then dbug("debug cmd_RestoreBackup triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetBlacklistResponse()

	if result then
		if debug then dbug("debug cmd_SetBlacklistResponse triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetBotAlertColour()

	if result then
		if debug then dbug("debug cmd_SetBotAlertColour triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetBotChatColour()

	if result then
		if debug then dbug("debug cmd_SetBotChatColour triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetBotName()

	if result then
		if debug then dbug("debug cmd_SetBotName triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetBotRestartDay()

	if result then
		if debug then dbug("debug cmd_SetBotRestartDay triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetBotWarningColour()

	if result then
		if debug then dbug("debug cmd_SetBotWarningColour triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetCommandPrefix()

	if result then
		if debug then dbug("debug cmd_SetCommandPrefix triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetMasterPassword()

	if result then
		if debug then dbug("debug cmd_SetMasterPassword triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetUpdateBranch()

	if result then
		if debug then dbug("debug cmd_SetUpdateBranch triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_ShutdownBot()

	if result then
		if debug then dbug("debug cmd_ShutdownBot triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_ToggleBotRestart()

	if result then
		if debug then dbug("debug cmd_ToggleBotRestart triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_ToggleBotUpdates()

	if result then
		if debug then dbug("debug cmd_ToggleBotUpdates triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_ToggleHackerTPDetection()

	if result then
		if debug then dbug("debug cmd_ToggleHackerTPDetection triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_ToggleLagCheck()

	if result then
		if debug then dbug("debug cmd_ToggleLagCheck triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_UpdateCode()

	if result then
		if debug then dbug("debug cmd_UpdateCode triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_WhitelistEveryone()

	if result then
		if debug then dbug("debug cmd_WhitelistEveryone triggered") end
		return result
	end

	if debug then dbug("debug bot end of remote commands") end

	-- ###################  do not run remote commands beyond this point unless displaying command help ################
	if chatvars.playerid == 0 and not chatvars.showHelp then
		botman.faultyChat = false
		return false
	end
	-- ###################  do not run remote commands beyond this point unless displaying command help ################

	if chatvars.showHelp and not skipHelp and chatvars.words[1] ~= "help" then
		irc_chat(chatvars.ircAlias, ".")
		irc_chat(chatvars.ircAlias, "Bot In-Game Only:")
		irc_chat(chatvars.ircAlias, "=================")
		irc_chat(chatvars.ircAlias, ".")
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_NoReset()

	if result then
		if debug then dbug("debug cmd_NoReset triggered") end
		return result
	end

	if (debug) then dbug("debug bot line " .. debugger.getinfo(1).currentline) end

	result = cmd_ResetServer()

	if result then
		if debug then dbug("debug cmd_ResetServer triggered") end
		return result
	end

	if debug then dbug("debug bot end") end

	-- can't touch dis
	if true then
		return result
	end
end
