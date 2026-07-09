local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization
local Images = UIBlox.App.ImageSet.Images
local TextKeys = require(ParentParent.Common.TextKeys)
local ContactsInformationModal = require(ParentParent.ContactsList.Components.ContactsInformationModal)
local v9 = Roact.PureComponent:extend("ContactsUploadErrorModal")

function v9.render(_) -- line: 14
	-- upvalues: withLocalization (copy), TextKeys (copy), Roact (copy), ContactsInformationModal (copy), Images (copy)
	return withLocalization({
		hasUploadError = TextKeys.UPLOAD_CONTACTS_FAILURE
	})(function(p2) -- line: 17
		-- upvalues: Roact (copy), ContactsInformationModal (copy), Images (copy)
		return Roact.createElement(ContactsInformationModal, {
			image = Images["icons/status/error_large"],
			text = p2.hasUploadError
		})
	end)
end

return v9
