local AppStorageService = game:GetService("AppStorageService")

local RoduxSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/RoduxSquads")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local fetchActiveSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/fetchActiveSquad")
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useCurrentSquadId")
local validateSquadId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/validateSquadId")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect

return function(): nil
	local v5 = useDispatch()
	local v6 = useCurrentSquadId() or ""
	local state, setState = React.useState(false)

	local v7 = React.useContext(SquadExternalContractContext).useIsChatEnabled()

	React.useEffect(function()
		if state then
			AppStorageService:SetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY, v6)
			AppStorageService:Flush()
		end
	end, { v6, state })

	useEffect(function()
		if not v7 then
			return
		end

		local item = AppStorageService:GetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY)
		local v8 = validateSquadId(item)

		if v8 and v6 == "" then
			v5(fetchActiveSquad())
		elseif item ~= "" and not v8 or v6 ~= "" and v6 ~= item then
			v5(RoduxSquads.Actions.CurrentSquadUpdated(nil))
			AppStorageService:SetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY, "")
			AppStorageService:Flush()
		end

		setState(true)
	end, { v7 })

	return nil
end
