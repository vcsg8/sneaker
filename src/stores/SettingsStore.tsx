import create from "zustand";

export enum GroundUnitMode {
  FRIENDLY = "friendly",
  ENEMY = "enemy",
}

export type SettingsStoreData = {
  map: {
    showTrackIcons?: boolean;
    showTrackLabels?: boolean;
    trackTrailLength?: number;
    groundUnitMode?: GroundUnitMode;
  };
  showAircraftTypeInTrackNames: boolean;
  coalition: string; // 'Allies' or 'Enemies'
};

export const settingsStore = create<SettingsStoreData>(() => {
  const localData = localStorage.getItem("settings");
  if (localData) {
    return JSON.parse(localData) as SettingsStoreData;
  }
  return {
    map: {
      showTrackIcons: true,
      showTrackLabels: true,
      trackTrailLength: 9,
      groundUnitMode: GroundUnitMode.FRIENDLY,
    },
    showAircraftTypeInTrackNames: true,
    coalition: "Allies",
  };
});

settingsStore.subscribe((state) => {
  localStorage.setItem("settings", JSON.stringify(state));
});
