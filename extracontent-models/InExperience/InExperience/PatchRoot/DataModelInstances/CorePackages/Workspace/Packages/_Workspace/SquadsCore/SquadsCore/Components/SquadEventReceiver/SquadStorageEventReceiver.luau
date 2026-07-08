local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local AppStorageService = game:GetService("AppStorageService")
local RoduxSquads = require(SquadsCore.RoduxSquads)
local Constants = require(SquadsCore.Common.Constants)
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local fetchActiveSquad = require(SquadsCore.Thunks.fetchActiveSquad)
local useCurrentSquadId = require(SquadsCore.Hooks.useCurrentSquadId)
local validateSquadId = require(SquadsCore.Common.validateSquadId)
local React = require(SquadsCoreParent.React)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect

return function() -- line: 18
	-- upvalues: useDispatch (copy), useCurrentSquadId (copy), React (copy), SquadExternalContractContext (copy), AppStorageService (copy), Constants (copy), useEffect (copy), validateSquadId (copy), fetchActiveSquad (copy), RoduxSquads (copy)
	local v13 = useDispatch()
	local v14 = useCurrentSquadId() or ""
	local v15, v16 = React.useState(false)
	local v17 = React.useContext(SquadExternalContractContext).useIsChatEnabled()

	React.useEffect(function() -- line: 27
		-- upvalues: v15 (copy), AppStorageService (copy), Constants (copy), v14 (copy)
		if v15 then
			AppStorageService:SetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY, v14)
			AppStorageService:Flush()
		end
	end, {
		v14,
		v15
	})
	useEffect(function() -- line: 35
		-- upvalues: v17 (copy), AppStorageService (copy), Constants (copy), validateSquadId (copy), v14 (copy), v13 (copy), fetchActiveSquad (copy), RoduxSquads (copy), v16 (copy)
		if not v17 then
			return
		end

		local Item = AppStorageService:GetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY)
		local v19 = validateSquadId(Item)

		if v19 and v14 == "" then
			v13(fetchActiveSquad())
		elseif Item ~= "" and not v19 or v14 ~= "" and Item ~= v14 then
			v13(RoduxSquads.Actions.CurrentSquadUpdated(nil))
			AppStorageService:SetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY, "")
			AppStorageService:Flush()
		end

		v16(true)
	end, { v17 })

	return nil
end
