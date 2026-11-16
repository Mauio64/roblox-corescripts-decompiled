require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Types")

return function(data): boolean
	return (not data.buttons or #data.buttons < 2)
		and (not data.labelItems or #data.labelItems == 0)
		and not (data.image or data.body or data.isDismissable)
end
