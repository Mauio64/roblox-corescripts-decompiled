local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local AppStorageService = game:GetService("AppStorageService")

local RoduxSquads = require(SquadsCore.RoduxSquads)
local Constants = require(SquadsCore.Common.Constants)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local fetchActiveSquad = require(SquadsCore.Thunks.fetchActiveSquad)
local useCurrentSquadId = require(SquadsCore.Hooks.useCurrentSquadId)
local validateSquadId = require(SquadsCore.Common.validateSquadId)

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect

return function(): nil
	local v = useDispatch()
	local v2 = useCurrentSquadId() or ""
	local state, setState = React.useState(false)

	local v3 = React.useContext(SquadExternalContractContext).useIsChatEnabled()

	React.useEffect(function()
		if state then
			AppStorageService:SetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY, v2)
			AppStorageService:Flush()
		end
	end, { v2, state })

	useEffect(function()
		if not v3 then
			return
		end

		local item = AppStorageService:GetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY)
		local v4 = validateSquadId(item)

		if v4 and v2 == "" then
			v(fetchActiveSquad())
		elseif item ~= "" and not v4 or v2 ~= "" and v2 ~= item then
			v(RoduxSquads.Actions.CurrentSquadUpdated(nil))
			AppStorageService:SetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY, "")
			AppStorageService:Flush()
		end

		setState(true)
	end, { v3 })

	return nil
end
