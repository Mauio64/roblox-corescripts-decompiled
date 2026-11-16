local parent = script.Parent.Parent.Parent.Parent
local dependencies = require(parent.dependencies)

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization

local images = uiBlox.App.ImageSet.Images
local TextKeys = require(parent.Common.TextKeys)
local ContactsInformationModal = require(parent.ContactsList.Components.ContactsInformationModal)

local extended = roact.PureComponent:extend("ContactsEmptyList")

extended.defaultProps = { errorTextKey = TextKeys.EMPTY_STATE }

function extended.render(p)
	local props = p.props

	return withLocalization({ emptyState = props.errorTextKey })(function(p2)
		return roact.createElement(ContactsInformationModal, {
			image = images["icons/status/oof_xlarge"],
			layoutOrder = props.layoutOrder,
			text = p2.emptyState
		})
	end)
end

return extended
