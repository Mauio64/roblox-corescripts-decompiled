local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Immutable = require(script.Parent.Parent.Immutable)

return function(p1, p2) -- line: 5
	-- upvalues: Rodux (copy), Immutable (copy)
	return Rodux.createReducer({
		clientSearchTerm = "",
		serverSearchTerm = "",
		clientTypeFilters = {},
		serverTypeFilters = {}
	}, {
		ClientLogAppendMessage = function(p3, p4) -- line: 13
			-- upvalues: Immutable (copy)
			return Immutable.JoinDictionaries(p3, {
				clientData = Immutable.Append(p3.clientData, p4.newMessage)
			})
		end,
		ServerLogAppendMessage = function(p5, p6) -- line: 19
			-- upvalues: Immutable (copy)
			return Immutable.JoinDictionaries(p5, {
				serverData = Immutable.Append(p5.serverData, p6.newMessage)
			})
		end,
		ClientLogAppendFilteredMessage = function(p7, p8) -- line: 25
			-- upvalues: Immutable (copy)
			local t1 = {
				clientData = Immutable.Append(p7.clientData, p8.newMessage),
				clientDataFiltered = Immutable.Append(p7.clientDataFiltered, p8.newMessage)
			}

			return Immutable.JoinDictionaries(p7, t1)
		end,
		ServerLogAppendFilteredMessage = function(p9, p10) -- line: 32
			-- upvalues: Immutable (copy)
			local t2 = {
				serverData = Immutable.Append(p9.serverData, p10.newMessage),
				serverDataFiltered = Immutable.Append(p9.serverDataFiltered, p10.newMessage)
			}

			return Immutable.JoinDictionaries(p9, t2)
		end,
		ClientLogSetData = function(p11, p12) -- line: 39
			-- upvalues: Immutable (copy)
			local t3 = {
				clientData = p12.newData,
				clientDataFiltered = p12.newDataFiltered
			}

			return Immutable.JoinDictionaries(p11, t3)
		end,
		ServerLogSetData = function(p13, p14) -- line: 46
			-- upvalues: Immutable (copy)
			local t4 = {
				serverData = p14.newData,
				serverDataFiltered = p14.newDataFiltered
			}

			return Immutable.JoinDictionaries(p13, t4)
		end,
		ClientLogUpdateSearchFilter = function(p15, p16) -- line: 53
			-- upvalues: Immutable (copy)
			local t5 = {
				clientSearchTerm = p16.searchTerm,
				clientTypeFilters = Immutable.JoinDictionaries(p15.clientTypeFilters, p16.filterTypes)
			}

			return Immutable.JoinDictionaries(p15, t5)
		end,
		ServerLogUpdateSearchFilter = function(p17, p18) -- line: 60
			-- upvalues: Immutable (copy)
			local t6 = {
				serverSearchTerm = p18.searchTerm,
				serverTypeFilters = Immutable.JoinDictionaries(p17.serverTypeFilters, p18.filterTypes)
			}

			return Immutable.JoinDictionaries(p17, t6)
		end
	})(p1, p2)
end
