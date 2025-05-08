require( "ui.uieditor.menus.StartMenu.T10StartMenu_GameOptions_ZM" )
require( "ui.uieditor.widgets.Lobby.Common.FE_TabBar" )

local PostLoadFunc = function ( self, controller )
	self:registerEventHandler( "menu_opened", function ()
		return true
	end )

	self.disableLeaderChangePopupShutdown = true

	if CoD.isCampaign then
		self:setModel( Engine.CreateModel( Engine.GetModelForController( controller ), "StartMenu_Main" ) )
	end

	if CoD.isZombie then
		self.disableDarkenElement = true
		self.disablePopupOpenCloseAnim = false
	end

	self:registerEventHandler( "open_migration_menu", function ( element, event )
		CloseAllOccludingMenus( element, controller )
		StartMenuResumeGame( element, event.controller )
		GoBack( element, event.controller )
	end )

	if CoD.isSafehouse and CoD.isOnlineGame() then
		SetGlobalModelValue( "combatRecordMode", "cp" )
	end

	SetControllerModelValue( controller, "forceScoreboard", 0 )
end

DataSources.StartMenuTabs = ListHelper_SetupDataSource( "StartMenuTabs", function ( controller )
	local tabList = {}

    if Engine.IsInGame() then
        if Engine.IsZombiesGame() then
			table.insert( tabList, {
				models = {
					tabName = "MENU_START_MENU_CAPS",
					tabWidget = "CoD.T10StartMenu_GameOptions_ZM",
					tabIcon = ""
				},
				properties = {
					tabId = "gameOptions"
				}
			} )
        end
    end

	return tabList
end, true )

LUI.createMenu.StartMenu_Main = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "StartMenu_Main" )

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.soundSet = "ChooseDecal"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "StartMenu_Main.buttonPrompts" )
	self.anyChildUsesUpdateState = true

	self.Background = LUI.UIImage.new()
	self.Background:setLeftRight( true, true, 0, 0 )
	self.Background:setTopBottom( true, true, 0, 0 )
	self.Background:setImage( RegisterImage( "$white" ) )
	self.Background:setRGB( 0, 0, 0 )
	self.Background:setAlpha( 0.5 )
	self:addElement( self.Background )

	self.RoundIcon = LUI.UIImage.new()
	self.RoundIcon:setLeftRight( true, false, 40 + 17, 106.5 + 17 )
	self.RoundIcon:setTopBottom( true, false, 23 + 22.5, 89.5 + 22.5 )
	self.RoundIcon:setImage( RegisterImage( "ximage_96144895a5ca00e" ) )
	self:addElement( self.RoundIcon )

	self.RoundTextShadow = LUI.UIText.new()
	self.RoundTextShadow:setLeftRight( true, true, -283 + 17, 0 + 17 )
	self.RoundTextShadow:setTopBottom( true, false, 0 + 18 + 22.5, 35 + 18 + 22.5 )
	self.RoundTextShadow:setText( Engine.Localize( "" ) )
	self.RoundTextShadow:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.RoundTextShadow:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	self.RoundTextShadow:setShaderVector( 0, 0.2, 0, 0, 0 )
	self.RoundTextShadow:setShaderVector( 1, 0.1, 0, 0, 0 )
	self.RoundTextShadow:setShaderVector( 2, 1, 0, 0, 0 )
	self.RoundTextShadow:setRGB( 0.2, 0.2, 0.2 )
	self.RoundTextShadow:setScale( 0.5 )
	self.RoundTextShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.RoundTextShadow:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "gameScore.roundsPlayed" ), function ( model )
		local roundsPlayed = Engine.GetModelValue( model )
		
		if roundsPlayed then
			if CoD.UsermapName ~= nil then
				self.RoundTextShadow:setText( string.upper( Engine.Localize( CoD.UsermapName ) ) .. " | STANDARD | ROUND " .. Engine.Localize( roundsPlayed - 1 ) )
			end
		end
	end )
	self:addElement( self.RoundTextShadow )

	self.RoundText = LUI.UIText.new()
	self.RoundText:setLeftRight( true, true, -283 + 17, 0 + 17 )
	self.RoundText:setTopBottom( true, false, 0 + 18 + 22.5, 35 + 18 + 22.5 )
	self.RoundText:setText( Engine.Localize( "" ) )
	self.RoundText:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.RoundText:setRGB( 0.89, 0.43, 0.09 )
	self.RoundText:setScale( 0.5 )
	self.RoundText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.RoundText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "gameScore.roundsPlayed" ), function ( model )
		local roundsPlayed = Engine.GetModelValue( model )
		
		if roundsPlayed then
			if CoD.UsermapName ~= nil then
				self.RoundText:setText( string.upper( Engine.Localize( CoD.UsermapName ) ) .. " | STANDARD | ROUND " .. Engine.Localize( roundsPlayed - 1 ) )
			end
		end
	end )
	self:addElement( self.RoundText )

	self.TitleShadow = LUI.UIText.new()
	self.TitleShadow:setLeftRight( true, true, -285 + 17, 0 + 17 )
	self.TitleShadow:setTopBottom( true, false, 0 + 22 + 22.5, 69 + 22 + 22.5 )
	self.TitleShadow:setText( Engine.Localize( "ROUND-BASED ZOMBIES" ) )
	self.TitleShadow:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.TitleShadow:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	self.TitleShadow:setShaderVector( 0, 0.2, 0, 0, 0 )
	self.TitleShadow:setShaderVector( 1, 0.1, 0, 0, 0 )
	self.TitleShadow:setShaderVector( 2, 1, 0, 0, 0 )
	self.TitleShadow:setRGB( 0.2, 0.2, 0.2 )
	self.TitleShadow:setScale( 0.5 )
	self.TitleShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.TitleShadow )

	self.Title = LUI.UIText.new()
	self.Title:setLeftRight( true, true, -285 + 17, 0 + 17 )
	self.Title:setTopBottom( true, false, 0 + 22 + 22.5, 69 + 22 + 22.5 )
	self.Title:setText( Engine.Localize( "ROUND-BASED ZOMBIES" ) )
	self.Title:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.Title:setScale( 0.5 )
	self.Title:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.Title )

	self.TitleDivider = LUI.UIImage.new()
	self.TitleDivider:setLeftRight( true, false, 108 + 17, 308 + 17 )
	self.TitleDivider:setTopBottom( true, false, 69.5 + 22.5, 73 + 22.5 )
	self.TitleDivider:setImage( RegisterImage( "ximage_63aafe44198a60e" ) )
	self.TitleDivider:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( self.TitleDivider )

	self.DescriptionTextShadow = LUI.UIText.new()
	self.DescriptionTextShadow:setLeftRight( true, true, -283 + 17, 0 + 17 )
	self.DescriptionTextShadow:setTopBottom( true, false, 0 + 18 + 22.5 + 47, 35 + 18 + 22.5 + 47 )
	self.DescriptionTextShadow:setText( Engine.Localize( CoD.UsermapDesc ) )
	self.DescriptionTextShadow:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.DescriptionTextShadow:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	self.DescriptionTextShadow:setShaderVector( 0, 0.2, 0, 0, 0 )
	self.DescriptionTextShadow:setShaderVector( 1, 0.1, 0, 0, 0 )
	self.DescriptionTextShadow:setShaderVector( 2, 1, 0, 0, 0 )
	self.DescriptionTextShadow:setRGB( 0.2, 0.2, 0.2 )
	self.DescriptionTextShadow:setScale( 0.5 )
	self.DescriptionTextShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.DescriptionTextShadow )

	self.DescriptionText = LUI.UIText.new()
	self.DescriptionText:setLeftRight( true, true, -283 + 17, 0 + 17 )
	self.DescriptionText:setTopBottom( true, false, 0 + 18 + 22.5 + 47, 35 + 18 + 22.5 + 47 )
	self.DescriptionText:setText( Engine.Localize( CoD.UsermapDesc ) )
	self.DescriptionText:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.DescriptionText:setRGB( 0.7, 0.7, 0.7 )
	self.DescriptionText:setScale( 0.5 )
	self.DescriptionText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.DescriptionText )

	self.MenuBackground = LUI.UIImage.new()
	self.MenuBackground:setLeftRight( false, true, -440, -26.5 )
	self.MenuBackground:setTopBottom( true, false, 0, 720 )
	self.MenuBackground:setImage( RegisterImage( "ximage_3b11ca7a7b8b046" ) )
	self:addElement( self.MenuBackground )

	self.HeaderBG1 = LUI.UIImage.new()
	self.HeaderBG1:setLeftRight( false, true, -440, -26.5 )
	self.HeaderBG1:setTopBottom( true, false, 70, 97.5 )
	self.HeaderBG1:setImage( RegisterImage( "$white" ) )
	self.HeaderBG1:setRGB( 0.07, 0.07, 0.07 )
	self:addElement( self.HeaderBG1 )

	self.HeaderBG2 = LUI.UIImage.new()
	self.HeaderBG2:setLeftRight( false, true, -440, -26.5 )
	self.HeaderBG2:setTopBottom( true, false, 97.5, 98 )
	self.HeaderBG2:setImage( RegisterImage( "$white" ) )
	self.HeaderBG2:setRGB( 0.2, 0.2, 0.2 )
	self:addElement( self.HeaderBG2 )

	self.Header = LUI.UIText.new()
	self.Header:setLeftRight( true, true, 741, 0 )
	self.Header:setTopBottom( true, false, 65.5, 106 )
	self.Header:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.Header:setText( Engine.Localize( "PAUSE" ) )
	self.Header:setRGB( 0.9, 0.9, 0.9 )
	self.Header:setScale( 0.5 )
	self.Header:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.Header )

	self.Credit = LUI.UIImage.new()
	self.Credit:setLeftRight( false, true, -387.5, -79 )
	self.Credit:setTopBottom( false, true, -308.5, 0 )
	self.Credit:setImage( RegisterImage( "ui_icon_kingslayer_kyle_signature" ) )
	self.Credit:setRGB( 0.15, 0.15, 0.15 )
	self.Credit:setScale( 0.8 )
	self:addElement( self.Credit )

	self.FETabBar = CoD.FE_TabBar.new( self, controller )
	self.FETabBar:setLeftRight( true, true, 0, 0 )
	self.FETabBar:setTopBottom( true, true, 0, 0 )
	self.FETabBar.FETabIdle00:setScale( 0 )
	self.FETabBar.Tabs.grid:setHorizontalCount( 8 )
	self.FETabBar.Tabs.grid:setDataSource( "StartMenuTabs" )
	self.FETabBar.Tabs.grid:setWidgetType( CoD.basicTabList )
	self.FETabBar.FETabIdle0:setScale( 0 )
	self:addElement( self.FETabBar )

	self.TabFrame = LUI.UIFrame.new( self, controller, 0, 0, false )
	self.TabFrame:setLeftRight( true, true, 876, 0 )
	self.TabFrame:setTopBottom( true, true, 185.5, 0 )
	self.TabFrame:linkToElementModel( self.FETabBar.Tabs.grid, "tabWidget", true, function ( model )
		local tabWidget = Engine.GetModelValue( model )

		if tabWidget then
			self.TabFrame:changeFrameWidget( tabWidget )
		end
	end )
	self:addElement( self.TabFrame )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		},
		IsFrontEnd = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		},
		Zombies = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		},
		Campaign = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		},
		Ingame = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "IsFrontEnd",
			condition = function ( menu, element, event )
				return InFrontend()
			end
		},
		{
			stateName = "Zombies",
			condition = function ( menu, element, event )
				return IsZombies()
			end
		},
		{
			stateName = "Campaign",
			condition = function ( menu, element, event )
				return IsCampaign()
			end
		},
		{
			stateName = "Ingame",
			condition = function ( menu, element, event )
				return IsInGame()
			end
		}
	} )

	self:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav" ), function ( model )
		self:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNav"
		} )
	end )

	self:registerEventHandler( "menu_loaded", function ( element, event )
		local retVal = nil
		
		PlaySoundSetSound( self, "menu_enter" )
		FileshareGetSlots( self, element, controller )
		SetHeadingKickerTextToGameMode( "" )
		PrepareOpenMenuInSafehouse( controller )

		if not retVal then
			retVal = element:dispatchEventToChildren( event )
		end

		return retVal
	end )

	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( element, menu, controller, model )
		RefreshLobbyRoom( menu, controller )
		StartMenuGoBack( menu, controller )

		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK" )

		return true
	end, false )
	
	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_START, "M", function ( element, menu, controller, model )
		RefreshLobbyRoom( menu, controller )
		StartMenuGoBack( menu, controller )

		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_START, "MENU_DISMISS_MENU" )

		return true
	end, false )

	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, nil, function ( element, menu, controller, model )
		PlaySoundSetSound( self, "list_action" )

		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )

		return true
	end, false )

	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_NONE, "ESCAPE", function ( element, menu, controller, model )
		RefreshLobbyRoom( menu, controller )
		StartMenuGoBack( menu, controller )

		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_NONE, "" )
		
		return true
	end, false, true )

	self.TabFrame.id = "TabFrame"

	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )

	self:processEvent( {
		name = "update_state",
		menu = self
	} )

	if not self:restoreState() then
		self.TabFrame:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Background:close()
		element.RoundIcon:close()
		element.RoundTextShadow:close()
		element.RoundText:close()
		element.TitleShadow:close()
		element.Title:close()
		element.TitleDivider:close()
		element.DescriptionTextShadow:close()
		element.DescriptionText:close()
		element.MenuBackground:close()
		element.HeaderBG1:close()
		element.HeaderBG2:close()
		element.Header:close()
		element.Credit:close()
		element.FETabBar:close()
		element.TabFrame:close()

		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "StartMenu_Main.buttonPrompts" ) )
	end )

	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end
