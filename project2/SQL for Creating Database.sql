CREATE TABLE Station
(
  StationName VARCHAR(100) NOT NULL,
  Longitude FLOAT NOT NULL,
  Zone VARCHAR(100) NOT NULL,
  Is_interchange INT NOT NULL,
  Weekend_Footfall FLOAT NOT NULL,
  Latitude FLOAT NOT NULL,
  StationID VARCHAR(100) NOT NULL,
  PRIMARY KEY (StationID)
);

CREATE TABLE Line
(
  LineID VARCHAR(100) NOT NULL,
  LineName VARCHAR(100) NOT NULL,
  PRIMARY KEY (LineID)
);

CREATE TABLE Weather_Condition
(
  WeatherID INT NOT NULL,
  Rainfall FLOAT NOT NULL,
  Temperature FLOAT NOT NULL,
  WindSpeed FLOAT NOT NULL,
  Timestamp DATE NOT NULL,
  StationID VARCHAR(100) NOT NULL,
  PRIMARY KEY (WeatherID),
  FOREIGN KEY (StationID) REFERENCES Station(StationID)
);

CREATE TABLE Passenger_Counts
(
  CountID VARCHAR(100) NOT NULL,
  TimeInterval VARCHAR(100) NOT NULL,
  PassengerCount INT NOT NULL,
  StationID VARCHAR(100) NOT NULL,
  PRIMARY KEY (CountID),
  FOREIGN KEY (StationID) REFERENCES Station(StationID)
);

CREATE TABLE Carbon_Emission
(
  EmissionID VARCHAR(100) NOT NULL,
  TotalPassengerCount FLOAT NOT NULL,
  EmissionRate FLOAT NOT NULL,
  TotalEmissions_kg FLOAT NOT NULL,
  TotalDistance_km FLOAT NOT NULL,
  PRIMARY KEY (EmissionID)
);

CREATE TABLE Contains_Station
(
  LineID VARCHAR(100) NOT NULL,
  StationID VARCHAR(100) NOT NULL,
  PRIMARY KEY (LineID, StationID),
  FOREIGN KEY (LineID) REFERENCES Line(LineID),
  FOREIGN KEY (StationID) REFERENCES Station(StationID)
);

CREATE TABLE Route
(
  RouteID VARCHAR(100) NOT NULL,
  RouteName VARCHAR(100) NOT NULL,
  StartStation VARCHAR(100) NOT NULL,
  EndStation VARCHAR(100) NOT NULL,
  LineID VARCHAR(100) NOT NULL,
  EmissionID VARCHAR(100) NOT NULL,
  PRIMARY KEY (RouteID),
  FOREIGN KEY (LineID) REFERENCES Line(LineID),
  FOREIGN KEY (EmissionID) REFERENCES Carbon_Emission(EmissionID)
);

CREATE TABLE RouteStation
(
  StationOrder INT NOT NULL,
  RouteID VARCHAR(100) NOT NULL,
  StationID VARCHAR(100) NOT NULL,
  PRIMARY KEY (RouteID, StationID),
  FOREIGN KEY (RouteID) REFERENCES Route(RouteID),
  FOREIGN KEY (StationID) REFERENCES Station(StationID)
);

CREATE TABLE Vehicle
(
  VehicleID VARCHAR(100) NOT NULL,
  LineID VARCHAR(100) NOT NULL,
  RouteID VARCHAR(100) NOT NULL,
  PRIMARY KEY (VehicleID),
  FOREIGN KEY (LineID) REFERENCES Line(LineID),
  FOREIGN KEY (RouteID) REFERENCES Route(RouteID)
);

CREATE TABLE Delay
(
  DelayID INT NOT NULL,
  DelayDuration INT NOT NULL,
  DelayType INT NOT NULL,
  TimeStamp INT NOT NULL,
  ImpactDetail INT NOT NULL,
  StationID VARCHAR(100) NOT NULL,
  VehicleID VARCHAR(100) NOT NULL,
  WeatherID INT,
  PRIMARY KEY (DelayID),
  FOREIGN KEY (StationID) REFERENCES Station(StationID),
  FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID),
  FOREIGN KEY (WeatherID) REFERENCES Weather_Condition(WeatherID)
);