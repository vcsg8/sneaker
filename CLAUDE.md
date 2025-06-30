# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Sneaker is a browser-based radar and GCI (Ground Controlled Intercept) simulation for DCS: World. It connects to Tacview real-time telemetry servers to display live battlefield information on an interactive map.

## Essential Commands

### Frontend Development
```bash
yarn install        # Install dependencies
yarn start          # Start development server on http://localhost:8090
yarn build          # Build production bundle
```

### Backend Development
```bash
go build -o sneaker-server ./cmd/sneaker-server  # Build server binary
go fmt ./...        # Format Go code
go vet ./...        # Run Go linter
```

### Running the Application
1. Configure `config.json` based on `example.config.json`
2. Start a Tacview server in DCS
3. Run the server: `./sneaker-server -config config.json`
4. Access the web interface at `http://localhost:80`

## Architecture

### Backend (Go)
- **Entry Point**: `cmd/sneaker-server/main.go`
- **Core Server**: `server/` directory
  - `http.go` - Chi router, HTTP endpoints, SSE/WebSocket handling
  - `tacview_client.go` - Connects to Tacview servers, parses telemetry
  - `state.go` - Manages server state and entity tracking
  - `session.go` - Client session management
  - `discord.go` - Discord bot integration
- **Static Assets**: Embedded via `assets.go` using Go embed
- **Real-time Updates**: Server-Sent Events (SSE) for telemetry streaming

### Frontend (React + TypeScript)
- **Entry Point**: `src/index.tsx`
- **Main Component**: `src/App.tsx`
- **State Management**: Zustand stores in `src/stores/`
  - `ServerStore` - Server connection and telemetry data
  - `TrackStore` - Entity tracking and filtering
  - `GeometryStore` - Map geometry (bullseyes, zones)
  - `ProfileStore` - User profiles and tags
- **Map Rendering**: MapTalks library via `src/components/Map.tsx`
- **WebWorker**: `src/worker.ts` for background coordinate calculations
- **DCS Maps**: Definitions in `src/dcs/maps/`
- **Build Tool**: Webpack with TypeScript

### Key Features
- Real-time entity tracking from Tacview
- Multiple DCS theater support (Caucasus, Syria, Persian Gulf, Marianas)
- Interactive map with entity filtering
- Profile system for tagging coalition members
- Discord integration for GCI coordination
- Geometry drawing (bullseyes, zones, lines)
- MGRS coordinate support

## Development Notes

- Frontend dev server runs on port 8090, production on port 80
- Tacview protocol implementation is custom (no official SDK)
- WebWorker handles expensive coordinate transformations
- No automated tests currently exist
- TypeScript strict mode is enabled
- TailwindCSS for styling with custom config