--[[
    Botman - A collection of scripts for managing 7 Days to Die servers
    Copyright (C) 2018  Matthew Dwyer
	           This copyright applies to the Lua source code in this Mudlet profile.
    Email     smegzor@gmail.com
    URL       http://botman.nz
    Source    https://bitbucket.org/mhdwyer/botman
--]]

local debug, result

debug = false -- should be false unless testing

if botman.debugAll then
	debug = true
end

function gmsg_shop()
	calledFunction = "gmsg_shop"
	result = false

-- ################## shop command functions ##################

	local function cmd_FixShop()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "shop"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "fix shop")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Attempt to automatically fix the shop.  It reloads the shop categories, checks for any missing categories in shop items and assigns them to misc then reindexes the shop.")
					irc_chat(chatvars.ircAlias, "This fix is experimental and might not actually fix whatever is wrong with your shop.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "fix" and chatvars.words[2] == "shop" then
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

			fixShop()

			if (chatvars.playername ~= "Server") then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Try using the shop and see if it is fixed.  If not repeating the command is not going to fix it this time.[-]")
			else
				irc_chat(chatvars.ircAlias, "Try using the shop and see if it is fixed.  If not repeating the command is not going to fix it this time.")
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetLotteryMultiplier()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "lott") or string.find(chatvars.command, "gamb"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set lottery multiplier {number}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Every zombie killed adds 1 x the lottery multiplier to the lottery total.  The higher the number, the faster the lottery rises.  The default is 2.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "lottery" and chatvars.words[3] == "multiplier" then
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

			if chatvars.number ~= nil then
				chatvars.number = math.abs(chatvars.number)

				server.lotteryMultiplier = chatvars.number
				conn:execute("UPDATE server SET lotteryMultiplier = " .. chatvars.number)

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The lottery will grow by zombie kills multiplied by " .. chatvars.number .. ".[-]")
				else
					irc_chat(chatvars.ircAlias, "The lottery will grow by zombie kills multiplied by " .. chatvars.number)
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetLotteryPrize()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "lott") or string.find(chatvars.command, "gamb"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set lottery prize {number}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "You can set or reset the lottery prize to any number.  Useful if it gets too large.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "lottery" and (chatvars.words[3] == "prize" or chatvars.words[3] == "value" or chatvars.words[3] == "cash") then
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

			if chatvars.number ~= nil then
				chatvars.number = math.abs(math.floor(chatvars.number))

				server.lottery = chatvars.number
				conn:execute("UPDATE server SET lottery = " .. chatvars.number)

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]You reset the daily lottery cash to " .. chatvars.number .. ".[-]")
				else
					irc_chat(chatvars.ircAlias, "You reset the daily lottery cash to " .. chatvars.number)
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ToggleLottery()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "lott") or string.find(chatvars.command, "gamb"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "open/close lottery")
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "enable/disable lottery")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Turn on or off the daily lottery.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "open" or chatvars.words[1] == "enable" or chatvars.words[1] == "close" or chatvars.words[1] == "disable") and chatvars.words[2] == "lottery" then
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

			if chatvars.words[1] == "open" or chatvars.words[1] == "enable" then
				server.allowLottery = true
				conn:execute("UPDATE server SET allowLottery = 1")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The daily lottery will run at midnight.[-]")
				else
					irc_chat(server.ircMain, "The daily lottery will run at midnight.")
				end
			else
				server.allowLottery = false
				conn:execute("UPDATE server SET allowLottery = 0")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The daily lottery is disabled.[-]")
				else
					irc_chat(server.ircMain, "The daily lottery is disabled.")
				end

			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetPlaytimeReward()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "pay") or string.find(chatvars.command, "rate"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set playtime reward {" .. server.moneyPlural .. "}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Set how many " .. server.moneyPlural .. " a player earns for each minutes played. (excludes new players)")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "playtime" and chatvars.words[3] == "reward" then
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

			if chatvars.number ~= nil then
				chatvars.number = math.abs(chatvars.number)

				server.perMinutePayRate = chatvars.number
				conn:execute("UPDATE server SET perMinutePayRate = " .. chatvars.number)

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Players will be rewarded " .. chatvars.number .. " " .. server.moneyPlural .. " for every minute played. (exludes new players and isn't retrospective)[-]")
				else
					irc_chat(chatvars.ircAlias, "Players will be rewarded " .. chatvars.number .. " " .. server.moneyPlural .. " for every minute played. (exludes new players and isn't retrospective)")
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetZombieReward()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "zom") or string.find(chatvars.command, "set"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set zombie reward {" .. server.moneyPlural .. "}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Set how many " .. server.moneyPlural .. " a player earns for each zombie killed.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "zombie" and chatvars.words[3] == "reward" then
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

			if chatvars.number ~= nil then
				chatvars.number = math.abs(chatvars.number)

				server.zombieKillReward = chatvars.number
				conn:execute("UPDATE server SET zombieKillReward = " .. chatvars.number)

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Players will be awarded " .. chatvars.number .. " " .. server.moneyPlural .. " for every zombie killed.[-]")
				else
					irc_chat(chatvars.ircAlias, "Players will be awarded " .. chatvars.number .. " " .. server.moneyPlural .. " for every zombie killed.")
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ToggleBank()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "bank") or string.find(chatvars.command, "cash"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "enable/disable bank")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Players can earn " .. server.moneyPlural .. " if the bank is enabled.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "enable" or chatvars.words[1] == "disable") and chatvars.words[2] == "bank" then
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
				server.allowBank = true
				conn:execute("UPDATE server SET allowBank = 1")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The bank is enabled.[-]")
				else
					irc_chat(chatvars.ircAlias, "This bank is enabled.")
				end
			else
				server.allowBank = false
				conn:execute("UPDATE server SET allowBank = 0")

				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The bank is disabled.[-]")
				else
					irc_chat(chatvars.ircAlias, "The bank is disabled.")
				end

			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetMoneyName()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "money") or string.find(chatvars.command, "name") or string.find(chatvars.command, "cash"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set money name {singular} {plural}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "The default money name is the Zenny and the plural is Zennies. Both names must be one word each.")
					irc_chat(chatvars.ircAlias, "eg " .. server.commandPrefix .. "set money name Chip Chips.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "money" and chatvars.words[3] == "name" then
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

			tmp = {}
			tmp.money = chatvars.wordsOld[4]
			tmp.moneyPlural = chatvars.wordsOld[5]

			if tmp.money ~= nil and tmp.moneyPlural ~= nil then
				-- first update the currency name in the locations table
				conn:execute("UPDATE locations SET currency = '" .. escape(tmp.money) .. "' where currency = '" .. escape(server.moneyName) .. "'")

				for k,v in pairs(locations) do
					if v.currency then
						if string.lower(v.currency) == string.lower(server.moneyName) then
							v.currency = tmp.money
						end
					end
				end

				server.moneyName = tmp.money
				server.moneyPlural = tmp.moneyPlural
				conn:execute("UPDATE server SET moneyName = '" .. escape(tmp.money .. "|" .. tmp.moneyPlural) .. "'")

				message("say [" .. server.chatColour .. "]This server now uses money called the " .. server.moneyName ..".  All your old currency is now worthless!  Just kidding xD[-]")
				message("say [" .. server.chatColour .. "]The shop is now accepting your hard won " .. server.moneyPlural ..".[-]")
			else
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.warnColour .. "]I know your money is worthless, but it still needs a name.[-]")
				else
					irc_chat(chatvars.ircAlias, "I know your money is worthless, but it still needs a name.")
				end
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_BuyTicket()
		if (chatvars.words[1] == "shop"or chatvars.words[1] == "buy") and chatvars.words[2] ~= "ticket" then
			if (chatvars.accessLevel > 2) and (server.allowShop == false) then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The shop is closed until further notice.[-]")
				botman.faultyChat = false
				return true
			end

			botman.faultyChat = doShop(chatvars.command, chatvars.playerid, chatvars.words)
			return true
		end
	end


	local function cmd_Cash()
		if (chatvars.words[1] == "cash" or chatvars.words[1] == server.moneyName or chatvars.words[1] == server.moneyPlural or chatvars.words[1] == "bank" or chatvars.words[1] == "wallet") then
			message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]You have " .. players[chatvars.playerid].cash .. " " .. server.moneyPlural .. " in the bank.[-]")
			botman.faultyChat = false
			return true
		end
	end


	local function cmd_PayPlayer()
		if (chatvars.words[1] == "pay" and chatvars.words[2] ~= nil) then
			id = LookupPlayer(chatvars.words[2])
			if (id ~= 0) then
				players[chatvars.playerid].botQuestion = "pay player"
				players[chatvars.playerid].botQuestionID = id
				players[chatvars.playerid].botQuestionValue = math.abs(chatvars.words[3])
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]You want to pay " .. math.abs(chatvars.words[3]) .. " " .. server.moneyPlural .. " to " .. players[id].name .. "? Type " .. server.commandPrefix .. "yes to complete the transaction or start over.[-]")
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_Lottery()
		if (chatvars.words[1] == "lottery" or chatvars.words[1] == "lotto" or chatvars.words[1] == "tickets") then
			message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The lottery prize pool has reached " .. server.lottery .. " " .. server.moneyPlural .. "![-]")
			cursor,errorString = conn:execute("SELECT count(ticket) as tickets FROM lottery WHERE steam = " .. chatvars.playerid)
			row = cursor:fetch({}, "a")

			if tonumber(row.tickets) > 0 then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]You have " .. row.tickets .. " tickets in the next draw![-]")
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_Gamble()
		if (chatvars.words[1] == "buy" and chatvars.words[2] == "ticket") or chatvars.words[1] == "gamble" then
			if chatvars.number == nil then chatvars.number = 1 end

			if players[chatvars.playerid].cash < (server.lotteryTicketPrice * math.abs(chatvars.number)) then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Sorry " .. players[chatvars.playerid].name .. " but you don't have enough " .. server.moneyPlural .. ".[-]")
				botman.faultyChat = false
				return true
			end


			for i=1,math.abs(chatvars.number),1 do
				found = false
				tries = 0
				gotTicket = false

				while not gotTicket do
					r = rand(100)

					cursor,errorString = conn:execute("SELECT * FROM memLottery WHERE steam = " .. chatvars.playerid .. " AND ticket = " .. r)
					rows = cursor:numrows()

					if rows > 0 then
						found = true
						break
					end

					if not found then
						conn:execute("INSERT INTO memLottery (steam, ticket) VALUES (" .. chatvars.playerid .. "," .. r .. ")")
						conn:execute("INSERT INTO lottery (steam, ticket) VALUES (" .. chatvars.playerid .. "," .. r .. ")")

						players[chatvars.playerid].cash = players[chatvars.playerid].cash - server.lotteryTicketPrice
						break
					end

					tries = tries + 1
					if (tries > 100) then
						break
					end
				end
			end

			conn:execute("UPDATE players SET cash = " .. players[chatvars.playerid].cash .. " WHERE steam = " .. chatvars.playerid)
			cursor,errorString = conn:execute("SELECT count(ticket) as tickets FROM lottery WHERE steam = " .. chatvars.playerid)
			row = cursor:fetch(row, "a")

			if tonumber(row.tickets) > 0 then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Good Luck!  You have " .. row.tickets .. " tickets in the next draw![-]")
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ToggleShowCash()
		if (chatvars.words[1] == "show" or chatvars.words[1] == "hide") and chatvars.words[2] == "cash" then
			if chatvars.words[1] == "show" then
				players[chatvars.playerid].watchCash = true
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]You will see your " .. server.moneyPlural .. " increase with each zombie kill.[-]")
				conn:execute("UPDATE players SET watchCash = 1 WHERE steam = " .. chatvars.playerid)
			else
				players[chatvars.playerid].watchCash = nil
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Your " .. server.moneyPlural .. " will not be reported with each zombie kill.[-]")
				conn:execute("UPDATE players SET watchCash = 0 WHERE steam = " .. chatvars.playerid)
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ToggleShop()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "shop"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "open/close shop")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Enable or disable the shop feature.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "open" or chatvars.words[1] == "close") and chatvars.words[2] == "shop" then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 1) then
					message(string.format("pm %s [%s]" .. restrictedCommandMessage(), chatvars.playerid, server.chatColour))
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

			if chatvars.words[1] == "close" then
				message("say [" .. server.chatColour .. "]The shop is closed until further notice.[-]")
				server.allowShop = false

				if botman.dbConnected then conn:execute("UPDATE server SET allowShop = 0") end
			else
				message("say [" .. server.chatColour .. "]The shop is open for business![-]")
				server.allowShop = true

				if botman.dbConnected then conn:execute("UPDATE server SET allowShop = 1") end
				loadShopCategories()
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetLotteryTicketPrice()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "shop"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set lottery ticket price {number}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "The default cost of a lottery ticket is 25 " .. server.moneyPlural .. ". You can change it to anything above 0.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "lottery" and chatvars.words[3] == "ticket" and chatvars.words[4] == "price" then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 1) then
					message(string.format("pm %s [%s]" .. restrictedCommandMessage(), chatvars.playerid, server.chatColour))
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

			if chatvars.number == nil then
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Missing number for ticket price.[-]")
				else
					irc_chat(chatvars.ircAlias, "Missing number for ticket price.")
				end

				botman.faultyChat = false
				return true
			else
				if chatvars.number == 0 then
					if (chatvars.playername ~= "Server") then
						message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Set a price higher than 0.[-]")
					else
						irc_chat(chatvars.ircAlias, "Set a price higher than 0.")
					end

					botman.faultyChat = false
					return true
				end

				chatvars.number = math.abs(chatvars.number)

				server.lotteryTicketPrice = chatvars.number
				if botman.dbConnected then conn:execute("UPDATE server SET lotteryTicketPrice = " .. chatvars.number) end

				message("say [" .. server.chatColour .. "]Tickets in the daily lottery now cost " .. server.lotteryTicketPrice .. " " .. server.moneyPlural .. ".[-]")
			end

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetShopResetDays()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "shop"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set shop reset days {number}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Restock the shop to the max quantity of each item every {number} of real days.")
					irc_chat(chatvars.ircAlias, "A setting of 0 disables the automatic restock.  To manually restock it use " .. server.commandPrefix .. "reset shop.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "shop" and chatvars.words[3] == "reset" and chatvars.words[4] == "days" then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 1) then
					message(string.format("pm %s [%s]" .. restrictedCommandMessage(), chatvars.playerid, server.chatColour))
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

			if chatvars.number == nil then
				if (chatvars.playername ~= "Server") then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]Missing number for days.[-]")
				else
					irc_chat(chatvars.ircAlias, "Missing number for days.")
				end

				botman.faultyChat = false
				return true
			else
				chatvars.number = math.abs(chatvars.number)

				server.shopResetDays = chatvars.number
				if botman.dbConnected then conn:execute("UPDATE server SET shopResetDays = " .. chatvars.number) end

				if chatvars.number == 0 then
					if (chatvars.playername ~= "Server") then
						message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The shop must be manually restocked. You can do that with " .. server.commandPrefix .. "reset shop.[-]")
					else
						irc_chat(chatvars.ircAlias, "The shop must be manually restocked. You can do that with " .. server.commandPrefix .. "reset shop.")
					end
				else
					if (chatvars.playername ~= "Server") then
						message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The shop will restock after " .. chatvars.number .. " days.[-]")
					else
						irc_chat(chatvars.ircAlias, "The shop will restock after " .. chatvars.number .. " days.")
					end
				end
			end


			botman.faultyChat = false
			return true
		end
	end


	local function cmd_ResetShop()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "shop"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "reset shop")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Restock the shop to the max quantity of each item.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "reset" and chatvars.words[2] == "shop") then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 1) then
					message(string.format("pm %s [%s]" .. restrictedCommandMessage(), chatvars.playerid, server.chatColour))
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

			message("say [" .. server.chatColour .. "]Hurrah!  >NEW< stock![-]")
			resetShop(true)
			loadShopCategories()

			botman.faultyChat = false
			return true
		end
	end


	local function cmd_SetShopTradingHours()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "shop"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set shop open/close {0 - 23}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Enter a number from 0 to 23 which will be the game hour that the shop opens or closes.")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if chatvars.words[1] == "set" and chatvars.words[2] == "shop" and (chatvars.words[3] == "open" or chatvars.words[3] == "close") then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 1) then
					message(string.format("pm %s [%s]" .. restrictedCommandMessage(), chatvars.playerid, server.chatColour))
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

			if chatvars.number == nil then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]A number from 0 to 23 is expected (military time)[-]")
				botman.faultyChat = false
				return true
			else
				chatvars.number = math.floor(chatvars.number)

				if tonumber(chatvars.number) < 0 or tonumber(chatvars.number) > 23 then
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]A number from 0 to 23 is expected (military time)[-]")
					botman.faultyChat = false
					return true
				end

				if chatvars.words[3] == "open" then
					server.shopOpenHour = chatvars.number
					if botman.dbConnected then conn:execute("UPDATE server SET shopOpenHour = " .. chatvars.number) end
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The shop opens at " .. chatvars.number .. ":00 hours[-]")
				else
					server.shopCloseHour = chatvars.number
					if botman.dbConnected then conn:execute("UPDATE server SET shopCloseHour = " .. chatvars.number) end
					message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]The shop closes at " .. chatvars.number .. ":00 hours[-]")
				end

				botman.faultyChat = false
				return true
			end
		end
	end


	local function cmd_SetClearShopLocation()
		if chatvars.showHelp and not skipHelp then
			if (chatvars.words[1] == "help" and (string.find(chatvars.command, "shop"))) or chatvars.words[1] ~= "help" then
				irc_chat(chatvars.ircAlias, " " .. server.commandPrefix .. "set/clear shop location {location name (for set only)}")

				if not shortHelp then
					irc_chat(chatvars.ircAlias, "Tie the shop to a location.  Buying from the shop will only be possible while in that location (excluding admins).")
					irc_chat(chatvars.ircAlias, "Or clear the location so that the shop can be accessed server wide. (the default)")
					irc_chat(chatvars.ircAlias, ".")
				end

				chatvars.helpRead = true
			end
		end

		if (chatvars.words[1] == "set" or chatvars.words[1] == "clear") and chatvars.words[2] == "shop" and chatvars.words[3] == "location" then
			if (chatvars.playername ~= "Server") then
				if (chatvars.accessLevel > 1) then
					message(string.format("pm %s [%s]" .. restrictedCommandMessage(), chatvars.playerid, server.chatColour))
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

			str = string.sub(chatvars.command, string.find(chatvars.command, "location ") + 9)
			str = string.trim(str)
			str = LookupLocation(str)

			if str == nil then
				message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]A location is required for this command.[-]")
				botman.faultyChat = false
				return true
			else
				if chatvars.words[1] == "set" then
					message("say [" .. server.chatColour .. "]The shop is now located at ".. str .. "[-]")
					server.shopLocation = str
					if botman.dbConnected then conn:execute("UPDATE server SET shopLocation = '" .. str .. "'") end
				else
					message("say [" .. server.chatColour .. "]The shop is now available server wide.[-]")
					server.shopLocation = ""
					if botman.dbConnected then conn:execute("UPDATE server SET shopLocation = ''") end
				end

				botman.faultyChat = false
				return true
			end
		end
	end

-- ################## End of command functions ##################

	-- don't proceed if there is no leading slash
	if (string.sub(chatvars.command, 1, 1) ~= server.commandPrefix and server.commandPrefix ~= "") then
		botman.faultyChat = false
		return false
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_FixShop()

	if result then
		if debug then dbug("debug cmd_FixShop triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_ResetShop()

	if result then
		if debug then dbug("debug cmd_ResetShop triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetClearShopLocation()

	if result then
		if debug then dbug("debug cmd_SetClearShopLocation triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetLotteryMultiplier()

	if result then
		if debug then dbug("debug cmd_SetLotteryMultiplier triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetLotteryPrize()

	if result then
		if debug then dbug("debug cmd_SetLotteryPrize triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetLotteryTicketPrice()

	if result then
		if debug then dbug("debug cmd_SetLotteryTicketPrice triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetShopResetDays()

	if result then
		if debug then dbug("debug cmd_SetShopResetDays triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetShopTradingHours()

	if result then
		if debug then dbug("debug cmd_SetShopTradingHours triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_ToggleLottery()

	if result then
		if debug then dbug("debug cmd_ToggleLottery triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetPlaytimeReward()

	if result then
		if debug then dbug("debug cmd_SetPlaytimeReward triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetZombieReward()

	if result then
		if debug then dbug("debug cmd_SetZombieReward triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_ToggleBank()

	if result then
		if debug then dbug("debug cmd_ToggleBank triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_ToggleShop()

	if result then
		if debug then dbug("debug cmd_ToggleBank triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_SetMoneyName()

	if result then
		if debug then dbug("debug cmd_SetMoneyName triggered") end
		return result
	end

	if debug then dbug("debug shop end of remote commands") end

	-- ###################  do not run remote commands beyond this point unless displaying command help ################
	if chatvars.playerid == 0 and not chatvars.showHelp then
		botman.faultyChat = false
		return false
	end
	-- ###################  do not run remote commands beyond this point unless displaying command help ################

	result = cmd_BuyTicket()

	if result then
		if debug then dbug("debug cmd_BuyTicket triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_Cash()

	if result then
		if debug then dbug("debug cmd_Cash triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_PayPlayer()

	if result then
		if debug then dbug("debug cmd_PayPlayer triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_Lottery()

	if result then
		if debug then dbug("debug cmd_Lottery triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_Gamble()

	if result then
		if debug then dbug("debug cmd_Gamble triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	result = cmd_ToggleShowCash()

	if result then
		if debug then dbug("debug cmd_ToggleShowCash triggered") end
		return result
	end

if debug then dbug("debug gmsg_shop line " .. debugger.getinfo(1).currentline) end

	if (chatvars.words[1] == "yes" and chatvars.words[2] == nil) then
		if players[chatvars.playerid].botQuestion == "pay player" then
			payPlayer()

			botman.faultyChat = false
			return true
		end
	end

	if debug then dbug("end debug gmsg_shop") end

	-- can't touch dis
	if true then
		return result
	end
end
