local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Immutable = require(script.Parent.Parent.Immutable)

return function(p, p2)
	return Rodux.createReducer(
		{
			clientSearchTerm = "",
			clientTypeFilters = {},
			serverSearchTerm = "",
			serverTypeFilters = {}
		},
		{
			ClientLogAppendMessage = function(p3, p4)
				return Immutable.JoinDictionaries(p3, {
					clientData = Immutable.Append(p3.clientData, p4.newMessage)
				})
			end,
			ServerLogAppendMessage = function(p3, p4)
				return Immutable.JoinDictionaries(p3, {
					serverData = Immutable.Append(p3.serverData, p4.newMessage)
				})
			end,
			ClientLogAppendFilteredMessage = function(p3, p4)
				local v = {
					clientData = Immutable.Append(p3.clientData, p4.newMessage),
					clientDataFiltered = Immutable.Append(p3.clientDataFiltered, p4.newMessage)
				}

				return Immutable.JoinDictionaries(p3, v)
			end,
			ServerLogAppendFilteredMessage = function(p3, p4)
				local v = {
					serverData = Immutable.Append(p3.serverData, p4.newMessage),
					serverDataFiltered = Immutable.Append(p3.serverDataFiltered, p4.newMessage)
				}

				return Immutable.JoinDictionaries(p3, v)
			end,
			ClientLogSetData = function(p3, p4)
				local v = { clientData = p4.newData, clientDataFiltered = p4.newDataFiltered }

				return Immutable.JoinDictionaries(p3, v)
			end,
			ServerLogSetData = function(p3, p4)
				local v = { serverData = p4.newData, serverDataFiltered = p4.newDataFiltered }

				return Immutable.JoinDictionaries(p3, v)
			end,
			ClientLogUpdateSearchFilter = function(p3, p4)
				local v = {
					clientSearchTerm = p4.searchTerm,
					clientTypeFilters = Immutable.JoinDictionaries(p3.clientTypeFilters, p4.filterTypes)
				}

				return Immutable.JoinDictionaries(p3, v)
			end,
			ServerLogUpdateSearchFilter = function(p3, p4)
				local v = {
					serverSearchTerm = p4.searchTerm,
					serverTypeFilters = Immutable.JoinDictionaries(p3.serverTypeFilters, p4.filterTypes)
				}

				return Immutable.JoinDictionaries(p3, v)
			end
		}
	)(
		p,
		p2
	)
end
