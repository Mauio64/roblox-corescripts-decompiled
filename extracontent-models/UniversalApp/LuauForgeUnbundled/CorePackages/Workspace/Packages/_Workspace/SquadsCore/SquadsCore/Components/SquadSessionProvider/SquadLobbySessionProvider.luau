local SessionService = game:GetService("SessionService")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local SquadLocationEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLocationEnum")
local SquadRootViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadRootViewType")
local SquadViewFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadViewFlags")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RobloxAppSessionization").SessionType

local context = React.createContext({
	updateMetadata = function() end
})

return {
	Context = context,
	Provider = function(p2)
		local v5 = React.useContext(SquadExternalContractContext)

		local v6 = v5.useSquadViewFlags()
		local v7 = v5.useSquadRootView()
		local v8

		if v5.squadLocation == SquadLocationEnum.InExperience then
			v8 = sessionType.StructuralIdentifier.SquadLobbyPageInExpSessionInfo
		else
			v8 = sessionType.StructuralIdentifier.SquadLobbyPageUASessionInfo
		end

		local v9 = not (bit32.band(v6, SquadViewFlags.SquadLobby) == 0) and v7 ~= SquadRootViewType.None

		local v10 = React.useCallback(function()
			local level1 = sessionType.StructuralIdentifier.Level1

			if level1 and SessionService:SessionExists(level1) and not SessionService:SessionExists(v8) then
				SessionService:SetSession(level1, v8, v8)
			end
		end, { v8, v5.squadLocation })

		local v11 = React.useCallback(function()
			if SessionService:SessionExists(v8) then
				SessionService:RemoveSession(v8)
			end
		end, { v8 })

		local v12 = React.useCallback(function(p3, p4)
			if SessionService:SessionExists(v8) then
				SessionService:SetMetadata(v8, p3, p4)
			else
				Logger:warning(
					"Squad {} session does not exist, cannot update metadata with key {}, value {}",
					v8,
					p3,
					p4
				)
			end
		end, { v8 })

		React.useEffect(function()
			if not v9 then
				return function() end
			end

			v10()

			return function()
				v11()
			end
		end, { v9, v10, v11 })

		return React.createElement(context.Provider, {
			value = { updateMetadata = v12 }
		}, p2.children)
	end
}
