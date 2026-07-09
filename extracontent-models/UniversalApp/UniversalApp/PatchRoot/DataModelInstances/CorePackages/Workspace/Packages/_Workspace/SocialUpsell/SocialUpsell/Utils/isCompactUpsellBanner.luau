local SocialUpsell = script:FindFirstAncestor("SocialUpsell")

require(SocialUpsell.Types)

return function(p1) -- line: 7
	return (not p1.buttons or #p1.buttons < 2) and ((not p1.labelItems or #p1.labelItems == 0) and (not p1.image and (not p1.body and not p1.isDismissable)))
end
