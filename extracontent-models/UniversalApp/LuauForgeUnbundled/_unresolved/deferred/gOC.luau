local module = require("@luauforge/bundled/fuD")

return function(callback, p2, p3)
	return function(object)
		callback(
			p2,
			object:getState().AvatarExperience.AvatarEditor.Categories.category,
			object:getState().AvatarExperience.AvatarEditor.Categories.subcategory,
			p3,
			module.getUserId(object:getState()),
			object:getState().AvatarExperience.Common.Widgets.WidgetInfo.RequestId
		)
	end
end
