local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization
local Images = UIBlox.App.ImageSet.Images
local TextKeys = require(ParentParent.Common.TextKeys)
local ContactsInformationModal = require(ParentParent.ContactsList.Components.ContactsInformationModal)
local v9 = Roact.PureComponent:extend("ContactsEmptyList")

v9.defaultProps = {
	errorTextKey = TextKeys.EMPTY_STATE
}

function v9.render(p1) -- line: 23
	-- upvalues: withLocalization (copy), Roact (copy), ContactsInformationModal (copy), Images (copy)
	local props = p1.props

	return withLocalization({
		emptyState = props.errorTextKey
	})(function(p2) -- line: 28
		-- upvalues: Roact (copy), ContactsInformationModal (copy), Images (copy), props (copy)
		return Roact.createElement(ContactsInformationModal, {
			image = Images["icons/status/oof_xlarge"],
			layoutOrder = props.layoutOrder,
			text = p2.emptyState
		})
	end)
end

return v9
