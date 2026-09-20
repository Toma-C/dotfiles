{-# OPTIONS_GHC -Wno-deprecations #-}
--IMPORTS--

import XMonad
import Data.Monoid
import System.Exit
import Graphics.X11.ExtraTypes.XF86
import XMonad.Util.EZConfig (additionalKeysP)



import XMonad.Util.SpawnOnce
import XMonad.Util.Run

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.InsertPosition

import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.ComboP
import XMonad.Layout.Reflect
import XMonad.Layout.LayoutBuilder
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.AutoMaster


import XMonad.Layout.NoBorders
import XMonad.Layout.AutoMaster
import XMonad.Layout.DragPane
import XMonad.Layout.Simplest
import XMonad.Layout.Master
import XMonad.Layout.Accordion
import XMonad.Layout.Master
import XMonad.Layout.Magnifier
import XMonad.Layout.Circle
import XMonad.Layout.Combo
import XMonad.Layout.TwoPane
import XMonad.Layout.DragPane
import XMonad.Layout.Tabbed
import XMonad.Layout.BinaryColumn
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.FocusTracking
import XMonad.Layout.Roledex
import XMonad.Layout.ResizableThreeColumns
import XMonad.Layout.Gaps
import XMonad.Layout.IfMax
import XMonad.Layout.Groups
import XMonad.Layout.Groups.Examples

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified XMonad.Util.ExtensibleState as XS

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--myTerminal      = "konsole"
myTerminal      = "kitty"
--myTerminal      = "xfce4-terminal"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
-- myFocusFollowsMouse = True
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#221F1F"
myFocusedBorderColor = "#E4950E"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
-- master toggle
newtype LastNonMaster = LastNonMaster (Maybe Window)
    deriving (Typeable, Read, Show)

instance ExtensionClass LastNonMaster where
    initialValue = LastNonMaster Nothing

rememberNonMaster :: X ()
rememberNonMaster = do
    ws <- gets windowset
    case W.stack (W.workspace (W.current ws)) of
        Just s | not (null (W.up s)) ->
            XS.put (LastNonMaster (Just (W.focus s)))
        _ -> return ()

toggleMaster :: X ()
toggleMaster = do
    ws <- gets windowset
    LastNonMaster lastWin <- XS.get

    case W.stack (W.workspace (W.current ws)) of
        Nothing -> return ()
        Just s
            | null (W.up s) ->
                maybe (return ()) (windows . W.focusWindow) lastWin
            | otherwise -> do
                XS.put (LastNonMaster (Just (W.focus s)))
                windows W.focusMaster
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. mod1Mask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch browser
    , ((modm .|. mod1Mask, xK_backslash), spawn "firefox")
    
    -- launch nvim 
    , ((modm .|. mod1Mask, xK_v), spawn "mate-terminal -e nvim")

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run -nb \"#110B0D\" -sb \"#E4950E\" -sf \"black\" -i -p \"run\" -c -l 10")

    -- launch gmrun
    , ((modm .|. mod1Mask, xK_p     ), spawn "gmrun")

    -- media keys
    
    -- Audio / Volume Controls
    , ((0, xF86XK_AudioRaiseVolume),  spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ((0, xF86XK_AudioLowerVolume),  spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ((0, xF86XK_AudioMute),         spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

    -- Screen Brightness Controls
    , ((0, xF86XK_MonBrightnessUp),   spawn "brightnessctl set +5%")
    , ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 5%-")




    -- overwatch mode on/off
    --, ((modm .|. mod1Mask,  xK_o     ), spawn "xrandr -s 1280x720; xinput set-prop \"PixArt Gaming Mouse\" 329 0")
   --- , ((modm .|. mod1Mask,  xK_o     ), spawn "xinput set-prop PixArt\\ Gaming\\ Mouse libinput\\ Middle\\ Emulation\\ Enabled 0;setxkbmap -option")
   --- , ((modm .|. mod1Mask,  xK_i     ), spawn "xinput set-prop PixArt\\ Gaming\\ Mouse libinput\\ Middle\\ Emulation\\ Enabled 1;setxkbmap -option grp:rctrl_toggle -option caps:swapescape")
   , ((modm .|. mod1Mask,  xK_o     ), spawn "xinput set-prop \"Logitech G203 LIGHTSYNC Gaming Mouse\" libinput\\ Middle\\ Emulation\\ Enabled 0;setxkbmap -option") , ((modm .|. mod1Mask,  xK_i     ), spawn "xinput set-prop \"Logitech G203 LIGHTSYNC Gaming Mouse\" libinput\\ Middle\\ Emulation\\ Enabled 1;setxkbmap -option grp:rctrl_toggle -option caps:swapescape")



    -- close focused window
    , ((modm .|. mod1Mask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. mod1Mask, xK_space ), sendMessage $ ToggleGaps)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    --, ((modm,               xK_m     ), windows W.focusMaster  )
    -- Toggle master
    , ((modm,               xK_m     ), toggleMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. mod1Mask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. mod1Mask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. mod1Mask , xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile && xmonad --restart")

    --windownavigation
    ,((modm .|. controlMask, xK_h), sendMessage $ pullGroup L)
    ,((modm .|. controlMask, xK_l), sendMessage $ pullGroup R)
    ,((modm .|. controlMask, xK_k), sendMessage $ pullGroup U)
    ,((modm .|. controlMask, xK_j), sendMessage $ pullGroup D)
   
    ,((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
    ,((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
    
    ,((modm .|. controlMask, xK_period), onGroup W.focusUp')
    ,((modm .|. controlMask, xK_comma), onGroup W.focusDown')

    , ((modm .|. mod1Mask, xK_Right ), sendMessage $ Move R)
    , ((modm .|. mod1Mask, xK_Left ), sendMessage $ Move L)
    , ((modm .|. mod1Mask, xK_Up ), sendMessage $ Move U)
    , ((modm .|. mod1Mask, xK_Down ), sendMessage $ Move D)
    , ((modm .|. mod1Mask, xK_s ), sendMessage $ SwapWindow)
    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, mod1Mask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-- LAYOUTS
myLayout =  ( smartSpacing 3 
            . gaps [(U,27), (R,10), (L,10), (D,10)] 
            . smartBorders 
            . avoidStruts 
            . windowNavigation )
            (tomb ||| Full) 
  where
     tiled   = Tall nmaster delta ratio
     tomb = (mastered delta ratio $ IfMax 1 Full splitcards)
     cards = (reflectVert $ (focusTracking Roledex))
     splitcards = Mirror $ (IfMax 2 (TwoPane delta half) (fixMastered (1/10000) ratio $ (focusTracking Roledex))) 
     nmaster = 1
     ratio   = 0.6
     half    = 1/2
     delta   = 5/100

-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook =  manageDocks <+> composeAll
    [ 
    --, isFullscreen                  --> doFullFloat
    insertPosition Below Newer
    , className =? "MPlayer"         --> doFloat
    , className =? "GLFW"            --> doFloat
    , className =? "battle.net.exe"  --> doFloat
    , className =? "xmessage"  --> doFloat
    , className =? "steam"           --> doShift "3"
    , className =? "steamwebhelper"  --> doShift "3"
    , resource  =? "desktop_window"  --> doIgnore
    , resource  =? "kdesktop"        --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = ewmhDesktopsEventHook 
 
------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return() 

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do 
  spawnOnce "picom --config ~/.config/picom/picom.conf &"
  spawnOnce "nitrogen --restore & "
  spawnOnce "conky"
  spawnOnce "xinput set-prop 13 341 0 1 0"
  spawnOnce "openrgb --startminimized --config /home/tomac/.config/OpenRGB --profile \"tomac.orp\" "



------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--

main = do
  xmproc <- spawnPipe "xmobar /home/tomac/.config/xmobar/xmobarrc "
  xmonad $ ewmhFullscreen . ewmh $ docks defaults 

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
      --  layoutHook         = spacingWithEdge 10 $ myLayout,
        layoutHook         = myLayout,
        manageHook         = myManageHook <+> manageHook defaultConfig,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
