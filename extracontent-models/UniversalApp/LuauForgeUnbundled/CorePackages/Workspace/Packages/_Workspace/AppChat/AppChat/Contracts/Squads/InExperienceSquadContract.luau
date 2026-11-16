local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SocialExperiments = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/SquadExternalContractProvider")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Enums")

local setSquadPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Actions").SetSquadPrompt
local closeSquadPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Actions").CloseSquadPrompt

local squadRootViewType = Enums.SquadRootViewType
local makeSquadContract = SquadExternalContractProvider.makeSquadContract

local InExperienceAppChatModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/InExperienceAppChatModal")

local squadCoordinationExperienceJoinExperimentation = SocialExperiments.SquadCoordinationExperienceJoinExperimentation

local SquadContract = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contracts/Squads/SquadContract")

return (makeSquadContract(Cryo.Dictionary.union(SquadContract, {
	setSquadPrompt = function(object, p2)
		object:dispatch(setSquadPrompt(p2))
	end,
	closeSquadPrompt = closeSquadPrompt,
	useSquadRootView = function()
		local useState = React.useState
		local v5

		if
			squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled
			and InExperienceAppChatModal.default:getVisible()
		then
			v5 = squadRootViewType.InExperienceAppChatModal
		else
			v5 = squadRootViewType.None
		end

		local state, setState = useState(v5)

		React.useEffect(function()
			local eventConnection = InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p2)
				if p2 then
					setState(squadRootViewType.InExperienceAppChatModal)
				else
					setState(squadRootViewType.None)
				end
			end)

			return function()
				if eventConnection then
					eventConnection:Disconnect()
				end
			end
		end, {})

		return state
	end
})))
