import React, { useState } from 'react';
import { Sun, Cloud, Calendar } from 'lucide-react';
import './App.css';

const LoginScreen = ({ onLogin }) => {
  const [isSignUp, setIsSignUp] = useState(false);
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    confirmPassword: ''
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    if (isSignUp) {
      if (formData.password !== formData.confirmPassword) {
        alert('Passwords do not match');
        return;
      }
      // In a real app, you'd make an API call here
      alert('Account created successfully!');
      onLogin(formData.email);
    } else {
      // In a real app, you'd validate credentials here
      if (formData.email && formData.password) {
        onLogin(formData.email);
      } else {
        alert('Please enter both email and password');
      }
    }
  };

  const handleInputChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  return (
    <div className="login-container">
      <div className="login-card">
        {/* Logo and Title */}
        <div className="login-header">
          <div className="logo-container">
            <Sun className="logo-sun" size={32} />
            <Cloud className="logo-cloud" size={32} />
            <Calendar className="logo-calendar" size={32} />
          </div>
          <h1 className="app-title">WeatherSync Scheduler</h1>
        </div>

        {/* Input Fields */}
        <div className="form-container">
          <div>
            <input
              type="email"
              name="email"
              placeholder="Email"
              value={formData.email}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>
          
          <div>
            <input
              type="password"
              name="password"
              placeholder="Password"
              value={formData.password}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          {isSignUp && (
            <div>
              <input
                type="password"
                name="confirmPassword"
                placeholder="Confirm Password"
                value={formData.confirmPassword}
                onChange={handleInputChange}
                className="form-input"
              />
            </div>
          )}

          <div className="button-container">
            {!isSignUp ? (
              <>
                <button
                  onClick={() => setIsSignUp(true)}
                  className="form-button"
                >
                  SIGN UP
                </button>
                <button
                  onClick={handleSubmit}
                  className="form-button"
                >
                  LOGIN
                </button>
              </>
            ) : (
              <>
                <button
                  onClick={handleSubmit}
                  className="form-button"
                >
                  CREATE ACCOUNT
                </button>
                <button
                  onClick={() => setIsSignUp(false)}
                  className="form-button"
                >
                  BACK TO LOGIN
                </button>
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

const MainApp = ({ user, onLogout }) => {
  const [weather, setWeather] = useState({
    location: 'Manila',
    temperature: '35°C',
    condition: 'Sunny',
    forecast: [
      { day: 'Today', high: 38, low: 32, condition: 'Sunny' },
      { day: 'Tomorrow', high: 36, low: 30, condition: 'Cloudy' },
      { day: 'Saturday', high: 36, low: 28, condition: 'Rainy' },
    ]
  });

  const [events, setEvents] = useState([
    { id: 1, title: 'Morning Run', time: '7:00 AM', weather: 'Sunny' },
    { id: 2, title: 'Lunch Meeting', time: '12:00 PM', weather: 'Cloudy' },
    { id: 3, title: 'Evening Walk', time: '6:00 PM', weather: 'Clear' },
  ]);

  return (
    <div className="main-app">
      {/* Header */}
      <div className="app-header">
        <div className="header-content">
          <div className="header-logo">
            <Sun className="header-sun" size={24} />
            <h1 className="header-title">WeatherSync Scheduler</h1>
          </div>
          <div className="header-user">
            <span className="welcome-text">Welcome, {user}</span>
            <button
              onClick={onLogout}
              className="logout-button"
            >
              Logout
            </button>
          </div>
        </div>
      </div>

      <div className="main-content">
        {/* Weather Card */}
        <div className="weather-card">
          <div className="weather-header">
            <div>
              <h2 className="weather-location">{weather.location}</h2>
              <p className="weather-condition">{weather.condition}</p>
            </div>
            <div className="weather-temp-container">
              <div className="weather-temperature">{weather.temperature}</div>
              <Cloud className="weather-icon" size={32} />
            </div>
          </div>
          
          <div className="forecast-grid">
            {weather.forecast.map((day, index) => (
              <div key={index} className="forecast-item">
                <div className="forecast-day">{day.day}</div>
                <div className="forecast-condition">{day.condition}</div>
                <div className="forecast-temp">{day.high}°/{day.low}°</div>
              </div>
            ))}
          </div>
        </div>

        {/* Schedule Card */}
        <div className="schedule-card">
          <div className="schedule-header">
            <h3 className="schedule-title">Today's Schedule</h3>
            <Calendar className="schedule-icon" size={24} />
          </div>
          
          <div className="events-container">
            {events.map((event) => (
              <div key={event.id} className="event-item">
                <div>
                  <div className="event-title">{event.title}</div>
                  <div className="event-time">{event.time}</div>
                </div>
                <div className="event-weather">
                  {event.weather}
                </div>
              </div>
            ))}
          </div>
          
          <button className="add-event-button">
            Add New Event
          </button>
        </div>
      </div>
    </div>
  );
};

const App = () => {
  const [user, setUser] = useState(null);

  const handleLogin = (email) => {
    setUser(email);
  };

  const handleLogout = () => {
    setUser(null);
  };

  return (
    <div>
      {!user ? (
        <LoginScreen onLogin={handleLogin} />
      ) : (
        <MainApp user={user} onLogout={handleLogout} />
      )}
    </div>
  );
};

export default App;