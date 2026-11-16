local parent = script:FindFirstAncestor("AppChat").Parent

local RoduxNetworking = require(script.Parent.RoduxNetworking)

local ShareLinksNetworking = require(parent.ShareLinksNetworking)
return ShareLinksNetworking.config({ roduxNetworking = RoduxNetworking })
