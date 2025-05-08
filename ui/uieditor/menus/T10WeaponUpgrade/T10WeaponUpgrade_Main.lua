require( "ui.uieditor.widgets.T10WeaponUpgrade.T10WeaponUpgradeTabWidget1" )
require( "ui.uieditor.widgets.T10WeaponUpgrade.T10WeaponUpgradeTabWidget2" )
require( "ui.uieditor.widgets.TabbedWidgets.T10WeaponUpgradeTabList" )

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
				Engine.SendMenuResponse( controller, "T10WeaponUpgrade_Main", "close" )
			end
		end
	end )
end

DataSources.T10WeaponUpgradeTabs = ListHelper_SetupDataSource( "T10WeaponUpgradeTabs", function ( controller )
	local tabList = {}

	table.insert( tabList, {
		models = {
			tabName = "AMMO MODS",
			tabWidget = "CoD.T10WeaponUpgradeTabWidget1",
		}
	} )

	table.insert( tabList, {
		models = {
			tabName = "WEAPON RARITY",
			tabWidget = "CoD.T10WeaponUpgradeTabWidget2",
		}
	} )
	
	return tabList
end, true )

LUI.createMenu.T10WeaponUpgrade_Main = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "T10WeaponUpgrade_Main" )

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self.soundSet = "ChooseDecal"
	self:setOwner( controller )
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "T10WeaponUpgrade_Main.buttonPrompts" )
	self.anyChildUsesUpdateState = true

	self.TitleBG = LUI.UIImage.new()
	self.TitleBG:setLeftRight( false, false, -194, 194 )
	self.TitleBG:setTopBottom( true, false, -8, 67.5 )
	self.TitleBG:setImage( RegisterImage( "ximage_3d65384d414d0b5" ) )
	self:addElement( self.TitleBG )

	self.Title = LUI.UIText.new()
	self.Title:setLeftRight( false, false, -194 - 100, 194 + 100 )
	self.Title:setTopBottom( true, false, -29.5, 84 )
	self.Title:setText( Engine.Localize( "THE ARSENAL" ) )
	self.Title:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.Title:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Title:setRGB( 0.79, 0.96, 0.98 )
	self.Title:setScale( 0.5 )
	self:addElement( self.Title )

	self.JunkBG = LUI.UIImage.new()
	self.JunkBG:setLeftRight( false, false, -111.5, 111.5 )
	self.JunkBG:setTopBottom( true, false, 61.5, 89 )
	self.JunkBG:setImage( RegisterImage( "ximage_64fe7882352e03d" ) )
	self.JunkBG:setAlpha( 0.4 )
	self:addElement( self.JunkBG )

	self.Junk1 = LUI.UIText.new()
	self.Junk1:setLeftRight( true, true, 315.5, 0 )
	self.Junk1:setTopBottom( true, false, 51, 100.5 )
	self.Junk1:setText( Engine.Localize( "MY SALVAGE" ) )
	self.Junk1:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.Junk1:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.Junk1:setRGB( 0.52, 0.47, 0.37 )
	self.Junk1:setScale( 0.5 )
	self:addElement( self.Junk1 )

	self.Junk2 = LUI.UIText.new()
	self.Junk2:setLeftRight( true, true, 495, 0 )
	self.Junk2:setTopBottom( true, false, 51, 100.5 )
	self.Junk2:setText( Engine.Localize( "" ) )
	self.Junk2:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.Junk2:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.Junk2:setRGB( 0.60, 0.58, 0.56 )
	self.Junk2:setScale( 0.5 )
	self.Junk2:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_junk" ), function ( model )
		local junk = Engine.GetModelValue( model )

		if junk then
			self.Junk2:setText( Engine.Localize( junk ) )
		end
	end )
	self:addElement( self.Junk2 )

	self.JunkIcon = LUI.UIImage.new()
	self.JunkIcon:setLeftRight( true, false, 660.5, 688.5 )
	self.JunkIcon:setTopBottom( true, false, 60.5, 88.5 )
	self.JunkIcon:setImage( RegisterImage( "ui_icons_zombie_squad_info_salvage" ) )
	self:addElement( self.JunkIcon )

	self.TabBackground = LUI.UIImage.new()
	self.TabBackground:setLeftRight( false, false, -525, 525 )
	self.TabBackground:setTopBottom( true, false, 483, 520 )
	self.TabBackground:setImage( RegisterImage( "ximage_3200ee2ff3c5ffa" ) )
	self.TabBackground:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_nineslice_normal" ) )
	self.TabBackground:setShaderVector( 0, 0, 0, 1, 0.33 )
	self.TabBackground:setupNineSliceShader( 0, 6 )
	self:addElement( self.TabBackground )

	self.Background = LUI.UIImage.new()
	self.Background:setLeftRight( false, false, -345.5, 345.5 )
	self.Background:setTopBottom( true, false, 508.5, 822 )
	self.Background:setImage( RegisterImage( "ximage_cec11001c3c7cdd" ) )
	self:addElement( self.Background )

	self.Divider = LUI.UIImage.new()
	self.Divider:setLeftRight( false, false, -128, 128 )
	self.Divider:setTopBottom( true, false, 557, 562.5 )
	self.Divider:setRGB( 0.65, 0.65, 0.65 )
	self.Divider:setImage( RegisterImage( "ximage_1a255f94884f6ae" ) )
	self:addElement( self.Divider )

	self.T10WeaponUpgradeTabList = CoD.T10WeaponUpgradeTabList.new( self, controller )
	self.T10WeaponUpgradeTabList:setLeftRight( true, true, 537, 0 )
	self.T10WeaponUpgradeTabList:setTopBottom( true, true, 490, 0 )
	self.T10WeaponUpgradeTabList.grid:setHorizontalCount( 2 )
	self.T10WeaponUpgradeTabList.grid:setDataSource( "T10WeaponUpgradeTabs" )
	self:addElement( self.T10WeaponUpgradeTabList )

	self.TabFrame = LUI.UIFrame.new( self, controller, 0, 0, false )
	self.TabFrame:setLeftRight( true, false, 0, 0 )
	self.TabFrame:setTopBottom( true, false, 0, 0 )
	self.TabFrame:linkToElementModel( self.T10WeaponUpgradeTabList.grid, "tabWidget", true, function ( model )
		local tabWidget = Engine.GetModelValue( model )

		if tabWidget then
			self.TabFrame:changeFrameWidget( tabWidget )
		end
	end )
	self:addElement( self.TabFrame )

	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( element, menu, controller, model )
		PlaySoundSetSound( self, "list_action" )

		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )

		return true
	end, false )
	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( element, menu, controller, model )
		Engine.SendMenuResponse( controller, "T10WeaponUpgrade_Main", "close" )
		GoBack( menu, controller )

		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK" )

		return true
	end, false )
	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_NONE, "ESCAPE", function ( element, menu, controller, model )
		Engine.SendMenuResponse( controller, "T10WeaponUpgrade_Main", "close" )
		GoBack( menu, controller )

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
		element.TitleBG:close()
		element.Title:close()
		element.JunkBG:close()
		element.Junk1:close()
		element.Junk2:close()
		element.JunkIcon:close()
		element.TabBackground:close()
		element.Background:close()
		element.Divider:close()
		element.T10WeaponUpgradeTabList:close()
		element.TabFrame:close()

		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "T10WeaponUpgrade_Main.buttonPrompts" ) )
	end )

	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end
