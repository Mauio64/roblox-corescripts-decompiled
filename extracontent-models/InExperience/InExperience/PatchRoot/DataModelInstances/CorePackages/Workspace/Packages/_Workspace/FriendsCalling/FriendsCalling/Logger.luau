local parent = script:FindFirstAncestor("FriendsCalling").Parent

local Loggers = require(parent.Loggers)
return Loggers.Logger:new("FriendsCalling")
