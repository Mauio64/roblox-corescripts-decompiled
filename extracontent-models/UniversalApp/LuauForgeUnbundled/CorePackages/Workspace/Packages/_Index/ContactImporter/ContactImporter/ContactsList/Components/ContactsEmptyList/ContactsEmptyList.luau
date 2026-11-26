local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization

local images = uiBlox.App.ImageSet.Images
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/TextKeys")
local ContactsInformationModal = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsInformationModal")

local extended = roact.PureComponent:extend("ContactsEmptyList")

extended.defaultProps = { errorTextKey = TextKeys.EMPTY_STATE }

function extended.render(p2)
	local props = p2.props

	return withLocalization({ emptyState = props.errorTextKey })(function(p3)
		return roact.createElement(ContactsInformationModal, {
			image = images["icons/status/oof_xlarge"],
			layoutOrder = props.layoutOrder,
			text = p3.emptyState
		})
	end)
end

return extended
