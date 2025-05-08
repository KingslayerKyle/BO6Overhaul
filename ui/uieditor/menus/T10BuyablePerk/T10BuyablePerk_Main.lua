require( "ui.uieditor.widgets.T10BuyablePerk.T10BuyablePerkButton1ListItem" )

local SetHeaderLabels = function ( self, controller )
	local controllerModel = Engine.GetModelForController( controller )
	local clientNum = Engine.GetClientNum( controller )
	local buttonListModel = self.buttonList:getModel()

	local nameModel = Engine.GetModel( buttonListModel, "name" )
	local descriptionModel = Engine.GetModel( buttonListModel, "description" )
	local hasPerkModel = Engine.GetModel( buttonListModel, "hasPerk" )
	local scoreModel = Engine.GetModel( buttonListModel, "score" )

	local name = Engine.GetModelValue( nameModel )
	local description = Engine.GetModelValue( descriptionModel )
	local hasPerk = Engine.GetModelValue( hasPerkModel )
	local score = Engine.GetModelValue( scoreModel )

	if name ~= nil and description ~= nil and hasPerk ~= nil and score ~= nil then
		if self.PerkInfo ~= nil and self.Description ~= nil and self.Score ~= nil then
			if hasPerk == true then
				self.PerkInfo:setTopBottom( true, false, 139, 202 )
				self.PerkInfo:setText( Engine.Localize( "^5" .. name .. " - ^1ALREADY PURCHASED" ) )
			else
				self.PerkInfo:setTopBottom( true, false, 124, 207 )
				self.PerkInfo:setText( Engine.Localize( "^5" .. name ) )
			end

			self.Description:setText( Engine.Localize( description ) )
			self.Score:setText( Engine.Localize( score ) )
		end
	end
end

local PostLoadFunc = function ( self, controller )
	self:registerEventHandler( "menu_opened", function ()
		return true
	end )

	self.disableDarkenElement = true
	self.disablePopupOpenCloseAnim = false

	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "forceScoreboard" ), function ( model )
		local forceScoreboard = Engine.GetModelValue( model )

		if forceScoreboard then
			if forceScoreboard == 1 then
				Engine.SendMenuResponse( controller, "T10BuyablePerk_Main", "close" )
			end
		end
	end )

	local models = {
		"name",
		"description",
		"hasPerk",
		"score"
	}

	for index = 1, #models do
		self:linkToElementModel( self.buttonList, models[index], true, function ( model )
			SetHeaderLabels( self, controller )
		end )
	end

	local controllerModel = Engine.GetModelForController( controller )
	local perksModel = Engine.GetModel( controllerModel, "hudItems.perks" )
	local scoreModel = Engine.GetModel( controllerModel, "PlayerList." .. Engine.GetClientNum( controller ) .. ".playerScore" )
	local scoreboardTeamCountModel = Engine.GetModel( Engine.GetGlobalModel(), "scoreboard.team1.count" )

	if CoD.ZMPerks ~= nil then
		for index = 1, #CoD.ZMPerks do
			self:subscribeToModel( Engine.GetModel( perksModel, CoD.ZMPerks[index].clientFieldName ), function ( model )
				self.buttonList:updateDataSource()
			end )
		end
	end

	self:subscribeToModel( scoreModel, function ( model )
		self.buttonList:updateDataSource()
	end )

	self:subscribeToModel( scoreboardTeamCountModel, function ( model )
		self.buttonList:updateDataSource()
	end )

	SetFocusToElement( self, "buttonList", controller )
end

DataSources.T10BuyablePerk = ListHelper_SetupDataSource( "T10BuyablePerk", function ( controller )
	local perks = {}

	local controllerModel = Engine.GetModelForController( controller )
	local perksModel = Engine.GetModel( controllerModel, "hudItems.perks" )
	local scoreModel = Engine.GetModel( Engine.GetModelForController( controller ), "PlayerList." .. Engine.GetClientNum( controller ) .. ".playerScore" )
	local scoreboardTeamCountModel = Engine.GetModel( Engine.GetGlobalModel(), "scoreboard.team1.count" )
	local score = Engine.GetModelValue( scoreModel )
	local scoreboardTeamCount = Engine.GetModelValue( scoreboardTeamCountModel )

	if CoD.ZMPerks ~= nil then
		for index = 1, #CoD.ZMPerks do
			local cost = CoD.ZMPerks[index].cost
			local specialty = CoD.ZMPerks[index].specialty

			if specialty == "specialty_quickrevive" then
				cost = scoreboardTeamCount > 1 and cost or math.floor( cost / 3 )
			end

			table.insert( perks, {
				models = {
					name = CoD.ZMPerks[index].name,
					cost = cost,
					description = CoD.ZMPerks[index].description,
					image = CoD.ZMPerks[index].image_buyable,
					hasPerk = Engine.GetModelValue( Engine.GetModel( perksModel, CoD.ZMPerks[index].clientFieldName ) ) > 0,
					score = score,
					action = function ( self, element, controller, actionParam, menu )
						Engine.SendMenuResponse( controller, "T10BuyablePerk_Main", cost .. "," .. specialty )
					end
				}
			} )
		end
	end

	return perks
end, true )

LUI.createMenu.T10BuyablePerk_Main = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "T10BuyablePerk_Main" )

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.soundSet = "ChooseDecal"
	self:setOwner( controller )
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "T10BuyablePerk_Main.buttonPrompts" )
	self.anyChildUsesUpdateState = true

	self.Background1 = LUI.UIImage.new()
	self.Background1:setLeftRight( true, false, 0, 417 )
	self.Background1:setTopBottom( true, true, -4.5, 4.5 )
	self.Background1:setImage( RegisterImage( "ximage_41cf2686ea8f82b" ) )
	self:addElement( self.Background1 )

	self.Background2 = LUI.UIImage.new()
	self.Background2:setLeftRight( true, false, 31.5, 381.5 )
	self.Background2:setTopBottom( true, false, 224, 648.5 )
	self.Background2:setImage( RegisterImage( "ximage_68ceb26cc87e33e" ) )
	self:addElement( self.Background2 )

	self.Divider1 = LUI.UIImage.new()
	self.Divider1:setLeftRight( true, false, 38, 374.5 )
	self.Divider1:setTopBottom( true, false, 110.5, 113.5 )
	self.Divider1:setImage( RegisterImage( "ximage_9ffbe69096e6d54" ) )
	self:addElement( self.Divider1 )

	self.Divider2 = LUI.UIImage.new()
	self.Divider2:setLeftRight( true, false, 79, 335.5 )
	self.Divider2:setTopBottom( true, false, 187, 193 )
	self.Divider2:setRGB( 0.65, 0.65, 0.65 )
	self.Divider2:setImage( RegisterImage( "ximage_1a255f94884f6ae" ) )
	self:addElement( self.Divider2 )

	self.TitleBG = LUI.UIImage.new()
	self.TitleBG:setLeftRight( true, false, 17.5, 394.5 )
	self.TitleBG:setTopBottom( true, false, 9.5, 73.5 )
	self.TitleBG:setImage( RegisterImage( "ximage_d4339745b2e5278" ) )
	self:addElement( self.TitleBG )

	self.Title = LUI.UIText.new()
	self.Title:setLeftRight( true, false, 20.5, 394.5 )
	self.Title:setTopBottom( true, false, 9.5 - 2, 74 - 2 )
	self.Title:setText( Engine.Localize( "^5DER WUNDERFIZZ" ) )
	self.Title:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.Title:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Title:setScale( 0.5 )
	self:addElement( self.Title )

	self.Header = LUI.UIText.new()
	self.Header:setLeftRight( true, false, -34.5, 339.5 )
	self.Header:setTopBottom( true, false, 57, 128 )
	self.Header:setText( Engine.Localize( "MY ESSENCE" ) )
	self.Header:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.Header:setRGB( 0.65, 0.65, 0.65 )
	self.Header:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Header:setScale( 0.5 )
	self:addElement( self.Header )

	self.ScoreIcon = LUI.UIImage.new()
	self.ScoreIcon:setLeftRight( true, false, 233, 272 )
	self.ScoreIcon:setTopBottom( true, false, 71, 110 )
	self.ScoreIcon:setImage( RegisterImage( "ui_icons_zombie_squad_info_essence" ) )
	self:addElement( self.ScoreIcon )

	self.Score = LUI.UIText.new()
	self.Score:setLeftRight( true, true, -64, 0 )
	self.Score:setTopBottom( true, false, 57, 128 )
	self.Score:setText( Engine.Localize( "" ) )
	self.Score:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.Score:setRGB( 0.74, 0.63, 0.16 )
	self.Score:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.Score:setScale( 0.5 )
	self:addElement( self.Score )

	self.Description = LUI.UIText.new()
	self.Description:setLeftRight( true, false, 0 - 300, 417 + 300 )
	self.Description:setTopBottom( true, false, 186.5, 216.5 )
	self.Description:setText( Engine.Localize( "" ) )
	self.Description:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.Description:setRGB( 0.65, 0.65, 0.65 )
	self.Description:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Description:setScale( 0.5 )
	self:addElement( self.Description )

	self.PerkInfo = LUI.UIText.new()
	self.PerkInfo:setLeftRight( true, false, 0 - 300, 417 + 300 )
	self.PerkInfo:setTopBottom( true, false, 124, 207 )
	self.PerkInfo:setText( Engine.Localize( "" ) )
	self.PerkInfo:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.PerkInfo:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.PerkInfo:setScale( 0.5 )
	self:addElement( self.PerkInfo )

	self.buttonList = LUI.UIList.new( self, controller, 13.5, 0, nil, true, false, 0, 0, false, false )
	self.buttonList:makeFocusable()
	self.buttonList:setLeftRight( true, true, 54.5, 0 )
	self.buttonList:setTopBottom( true, true, 244.5, 0 )
	self.buttonList:setWidgetType( CoD.T10BuyablePerkButton1ListItem )
	self.buttonList:setHorizontalCount( 4 )
	self.buttonList:setVerticalCount( 4 )
	self.buttonList:setDataSource( "T10BuyablePerk" )
	self:AddButtonCallbackFunction( self.buttonList, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( element, menu, controller, model )
		ProcessListAction( self, element, controller )

		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )

		return true
	end, false )
	self:AddButtonCallbackFunction( self.buttonList, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( element, menu, controller, model )
		Engine.SendMenuResponse( controller, "T10BuyablePerk_Main", "close" )
		GoBack( menu, controller )
	
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK" )
	
		return true
	end, false )
	self:AddButtonCallbackFunction( self.buttonList, controller, Enum.LUIButton.LUI_KEY_NONE, "ESCAPE", function ( element, menu, controller, model )
		Engine.SendMenuResponse( controller, "T10BuyablePerk_Main", "close" )
		GoBack( menu, controller )
	
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_NONE, "" )
	
		return true
	end, false )
	self:addElement( self.buttonList )

	self.buttonList.id = "buttonList"

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Background1:close()
		element.Background2:close()
		element.Divider1:close()
		element.Divider2:close()
		element.TitleBG:close()
		element.Title:close()
		element.Header:close()
		element.ScoreIcon:close()
		element.Score:close()
		element.Description:close()
		element.PerkInfo:close()
		element.buttonList:close()

		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "T10BuyablePerk_Main.buttonPrompts" ) )
	end )

	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end
