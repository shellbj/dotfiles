import XMonad

import XMonad.Config.Xfce

import XMonad.Layout.Reflect
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.Circle
import XMonad.Layout.PerWorkspace
import XMonad.Layout.NoBorders
import XMonad.Layout.ShowWName
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances

import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

import Data.Ratio ((%))

import qualified Data.Map as M

myWorkspaces = ["web", "mail", "emacs" ] ++ map show [4..9]

myManageHook :: ManageHook
myManageHook = composeAll . concat $
               [ [ isFullscreen --> doFullFloat ]
               , [ isDialog --> doCenterFloat ]
               , [ (className =? c <||> title =? c <||> resource =? c) --> doIgnore | c <- ignores ]
               , [ (className =? c <||> title =? c <||> resource =? c) --> doCenterFloat | c <- cfloat ]
               , [ (className =? c <||> title =? c <||> resource =? c) --> doFloat | c <- float ]
               , [ (className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 0) | c <- web ]
               , [ (className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 1) | c <- mail ]
               , [ (className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 2) | c <- emacs ]
               ]
                where
                  web = [ "Chromium-browser", "Google-chrome", "chromium-browser", "chromium-dev" ]
                  mail = [ "Pidgin", "Thunderbird" ]
                  emacs = [ "emacs", "Emacs" ]
                  ignores = [ "Xfce4-notifyd"  -- notifications will steal focus otherwise
                            , "Whisker Menu"
                            ]
                  cfloat = [ "Xfce4-appfinder"
                           , "Xfrun4"
                             -- , "Xfce4-notes"
                           ]
                  float = [ "MPlayer"
                            -- , "Wrapper"
                             -- , "Gimp"
                             -- , "Xfce4-panel"
                             -- , "Xfce4-mcs-manager"
                             -- , "Xfce4-mixer"
                           ]

myLayoutHook = avoidStruts . smartBorders . showWName
               $ mkToggle(NBFULL ?? MIRROR ?? EOT)
               $ onWorkspaces ["mail", (myWorkspaces !! 1)] (reflectHoriz $ withIM (1%7) (Title "Buddy List") layout)
               $ layout
               where
                 layout = ( tiled ||| (Mirror tiled) ||| noBorders Full ||| Grid ||| Circle )
                 tiled = Tall nmaster delta ratio
                 nmaster = 1
                 ratio = 1/2
                 delta = 3/100

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask, xK_f), sendMessage $ Toggle NBFULL)
    , ((modMask .|. shiftMask, xK_f), sendMessage $ Toggle MIRROR)
    ]

main :: IO()
main = xmonad $ xfceConfig {
  manageHook = myManageHook <+> manageHook xfceConfig
  , workspaces = myWorkspaces
  , terminal = "xfce4-terminal"
  , modMask = mod4Mask
  , layoutHook = myLayoutHook
  , keys = myKeys <+> keys xfceConfig
  , startupHook = setWMName "LG3D" <+> startupHook xfceConfig -- hack for Java to display correctly
  }
