import React, { useState, useEffect } from 'react';
import DriverLogin from './DriverLogin';
import DriverDashboard from './DriverDashboard';
import { useLocation, useNavigate } from 'react-router-dom';

const DRIVER_SESSION_KEY = 'ridepilot_driver_session';

export default function DriverApp() {
  const [driver, setDriver] = useState<{id: string, name: string, uuid: string} | null>(() => {
    const saved = localStorage.getItem(DRIVER_SESSION_KEY);
    if (saved) {
      try {
        return JSON.parse(saved);
      } catch {
        return null;
      }
    }
    return null;
  });
  const location = useLocation();
  const navigate = useNavigate();

  useEffect(() => {
    if (location.state) {
      navigate('/driver', { replace: true, state: {} });
    }
  }, [location.state, navigate]);

  const handleDriverLogin = (driverId: string, driverName: string, driverUuid: string) => {
    console.log('Driver login successful:', { driverId, driverName, driverUuid });
    const driverData = { id: driverId, name: driverName, uuid: driverUuid };
    setDriver(driverData);
    localStorage.setItem(DRIVER_SESSION_KEY, JSON.stringify(driverData));
  };

  const handleDriverLogout = () => {
    console.log('Driver logout');
    setDriver(null);
    localStorage.removeItem(DRIVER_SESSION_KEY);
    navigate('/driver', { replace: true, state: {} });
  };

  if (!driver) {
    return <DriverLogin onDriverLogin={handleDriverLogin} />;
  }

  return (
    <DriverDashboard 
      driverId={driver.id}
      driverName={driver.name}
      driverUuid={driver.uuid}
      onLogout={handleDriverLogout}
    />
  );
}