local ExperienceStoreServerDrivenUi = script:FindFirstAncestor("ExperienceStoreServerDrivenUi")
local parent = ExperienceStoreServerDrivenUi.Parent
local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiGameItemsComponent = SharedFlags.FFlagSduiGameItemsComponent
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiLocalFeedFilter = SharedFlags2.FFlagSduiLocalFeedFilter

local registerExperienceStoreActions = require(ExperienceStoreServerDrivenUi.Actions.registerExperienceStoreActions)

local registerExperienceStoreComponents = require(ExperienceStoreServerDrivenUi.System.registerExperienceStoreComponents)

local function SduiExperienceStoreRegister(): nil
	React.useEffect(function()
		registerExperienceStoreActions()

		if FFlagSduiGameItemsComponent or FFlagSduiLocalFeedFilter then
			registerExperienceStoreComponents()
		end
	end, {})
	return nil
end

return React.memo(SduiExperienceStoreRegister)
