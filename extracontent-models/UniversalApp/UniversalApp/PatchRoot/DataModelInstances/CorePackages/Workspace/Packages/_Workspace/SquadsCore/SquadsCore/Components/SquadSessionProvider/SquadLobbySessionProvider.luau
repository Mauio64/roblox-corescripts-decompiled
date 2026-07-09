local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local SessionService = game:GetService("SessionService")
local Logger = require(SquadsCore.Logger)
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadLocationEnum = require(SquadsCore.Enums.SquadLocationEnum)
local SquadRootViewType = require(SquadsCore.Enums.SquadRootViewType)
local SquadViewFlags = require(SquadsCore.Components.SquadExternalContractProvider.SquadViewFlags)
local React = require(SquadsCoreParent.React)
local SessionType = require(SquadsCoreParent.RobloxAppSessionization).SessionType
local v11 = React.createContext({
	updateMetadata = function() -- line: 29
	end
})

return {
	Context = v11,
	Provider = function(t1: {[any]: any}) -- line: 32
		-- upvalues: React (copy), SquadExternalContractContext (copy), SquadLocationEnum (copy), SessionType (copy), SquadViewFlags (copy), SquadRootViewType (copy), SessionService (copy), Logger (copy), v11 (copy)
		local v13 = React.useContext(SquadExternalContractContext)
		local v14 = v13.useSquadViewFlags()
		local v15 = v13.useSquadRootView()
		local v16 = if v13.squadLocation ~= SquadLocationEnum.InExperience then SessionType.StructuralIdentifier.SquadLobbyPageUASessionInfo else SessionType.StructuralIdentifier.SquadLobbyPageInExpSessionInfo
		local v17 = bit32.band(v14, SquadViewFlags.SquadLobby) ~= 0 and v15 ~= SquadRootViewType.None
		local v18 = React.useCallback(function() -- line: 44
			-- upvalues: SessionType (copy), SessionService (copy), v16 (copy)
			local Level1 = SessionType.StructuralIdentifier.Level1

			if Level1 and (SessionService:SessionExists(Level1) and not SessionService:SessionExists(v16)) then
				SessionService:SetSession(Level1, v16, v16)
			end
		end, {
			v16,
			v13.squadLocation
		})
		local v19 = React.useCallback(function() -- line: 52
			-- upvalues: SessionService (copy), v16 (copy)
			if SessionService:SessionExists(v16) then
				SessionService:RemoveSession(v16)
			end
		end, { v16 })
		local v20 = React.useCallback(function(p1, p2) -- line: 58
			-- upvalues: SessionService (copy), v16 (copy), Logger (copy)
			if SessionService:SessionExists(v16) then
				SessionService:SetMetadata(v16, p1, p2)

				return
			end

			Logger:warning("Squad {} session does not exist, cannot update metadata with key {}, value {}", v16, p1, p2)
		end, { v16 })

		React.useEffect(function() -- line: 71
			-- upvalues: v17 (copy), v18 (copy), v19 (copy)
			if v17 then
				v18()

				return function() -- line: 75
					-- upvalues: v19 (copy)
					v19()
				end
			end

			return function() -- line: 80
			end
		end, {
			v17,
			v18,
			v19
		})

		return React.createElement(v11.Provider, {
			value = {
				updateMetadata = v20
			}
		}, t1.children)
	end
}
