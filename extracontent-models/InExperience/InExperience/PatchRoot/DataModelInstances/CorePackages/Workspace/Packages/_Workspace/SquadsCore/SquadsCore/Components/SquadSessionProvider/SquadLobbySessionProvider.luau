local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local SessionService = game:GetService("SessionService")

local Logger = require(SquadsCore.Logger)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadLocationEnum = require(SquadsCore.Enums.SquadLocationEnum)
local SquadRootViewType = require(SquadsCore.Enums.SquadRootViewType)
local SquadViewFlags = require(SquadsCore.Components.SquadExternalContractProvider.SquadViewFlags)

local React = require(parent.React)
local RobloxAppSessionization = require(parent.RobloxAppSessionization)

local SessionType = RobloxAppSessionization.SessionType

local context = React.createContext({
	updateMetadata = function() end
})

return {
	Context = context,
	Provider = function(p)
		local v = React.useContext(SquadExternalContractContext)

		local v2 = v.useSquadViewFlags()
		local v3 = v.useSquadRootView()
		local v4

		if v.squadLocation == SquadLocationEnum.InExperience then
			v4 = SessionType.StructuralIdentifier.SquadLobbyPageInExpSessionInfo
		else
			v4 = SessionType.StructuralIdentifier.SquadLobbyPageUASessionInfo
		end

		local v5

		if bit32.band(v2, SquadViewFlags.SquadLobby) == 0 then
			v5 = false
		else
			v5 = v3 ~= SquadRootViewType.None
		end

		local v6 = React.useCallback(function()
			local level1 = SessionType.StructuralIdentifier.Level1

			if level1 and SessionService:SessionExists(level1) and not SessionService:SessionExists(v4) then
				SessionService:SetSession(level1, v4, v4)
			end
		end, { v4, v.squadLocation })

		local v7 = React.useCallback(function()
			if SessionService:SessionExists(v4) then
				SessionService:RemoveSession(v4)
			end
		end, { v4 })

		local updateMetadata = React.useCallback(function(p2, p3)
			if SessionService:SessionExists(v4) then
				SessionService:SetMetadata(v4, p2, p3)
			else
				Logger:warning(
					"Squad {} session does not exist, cannot update metadata with key {}, value {}",
					v4,
					p2,
					p3
				)
			end
		end, { v4 })

		React.useEffect(function()
			if not v5 then
				return function() end
			end

			v6()

			return function()
				v7()
			end
		end, { v5, v6, v7 })

		return React.createElement(context.Provider, {
			value = { updateMetadata = updateMetadata }
		}, p.children)
	end
}
