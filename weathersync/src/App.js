import React, { useState } from 'react';
import { Sun, Cloud, Calendar } from 'lucide-react';


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
    <div className="min-h-screen bg-gradient-to-br from-teal-200 via-green-200 to-blue-200 flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl shadow-2xl p-8 w-full max-w-sm mx-auto border-8 border-black">
        {/* Logo and Title */}
        <div className="text-center mb-8">
          <div className="flex justify-center items-center gap-2 mb-4">
            <Sun className="text-orange-400" size={32} />
            <Cloud className="text-blue-400" size={32} />
            <Calendar className="text-gray-600" size={32} />
          </div>
          <h1 className="text-2xl font-bold text-gray-800">WeatherScheduler</h1>
        </div>

        {/* Input Fields */}
        <div className="space-y-4">
          <div>
            <input
              type="email"
              name="email"
              placeholder="Email"
              value={formData.email}
              onChange={handleInputChange}
              className="w-full px-4 py-3 rounded-full bg-gray-100 border-none outline-none focus:bg-gray-200 text-gray-800"
            />
          </div>
          
          <div>
            <input
              type="password"
              name="password"
              placeholder="Password"
              value={formData.password}
              onChange={handleInputChange}
              className="w-full px-4 py-3 rounded-full bg-gray-100 border-none outline-none focus:bg-gray-200 text-gray-800"
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
                className="w-full px-4 py-3 rounded-full bg-gray-100 border-none outline-none focus:bg-gray-200 text-gray-800"
              />
            </div>
          )}

          <div className="space-y-3 mt-6">
            {!isSignUp ? (
              <>
                <button
                  onClick={() => setIsSignUp(true)}
                  className="w-full py-3 rounded-full bg-gray-200 text-gray-800 font-medium hover:bg-gray-300 transition-colors"
                >
                  SIGN UP
                </button>
                <button
                  onClick={handleSubmit}
                  className="w-full py-3 rounded-full bg-gray-200 text-gray-800 font-medium hover:bg-gray-300 transition-colors"
                >
                  LOGIN
                </button>
              </>
            ) : (
              <>
                <button
                  onClick={handleSubmit}
                  className="w-full py-3 rounded-full bg-gray-200 text-gray-800 font-medium hover:bg-gray-300 transition-colors"
                >
                  CREATE ACCOUNT
                </button>
                <button
                  onClick={() => setIsSignUp(false)}
                  className="w-full py-3 rounded-full bg-gray-200 text-gray-800 font-medium hover:bg-gray-300 transition-colors"
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
    location: 'New York',
    temperature: '72°F',
    condition: 'Partly Cloudy',
    forecast: [
      { day: 'Today', high: 75, low: 65, condition: 'Sunny' },
      { day: 'Tomorrow', high: 73, low: 63, condition: 'Cloudy' },
      { day: 'Saturday', high: 70, low: 60, condition: 'Rainy' },
    ]
  });

  const [events, setEvents] = useState([
    { id: 1, title: 'Morning Run', time: '7:00 AM', weather: 'Sunny' },
    { id: 2, title: 'Lunch Meeting', time: '12:00 PM', weather: 'Cloudy' },
    { id: 3, title: 'Evening Walk', time: '6:00 PM', weather: 'Clear' },
  ]);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-teal-50">
      {/* Header */}
      <div className="bg-white shadow-sm p-4">
        <div className="flex justify-between items-center max-w-4xl mx-auto">
          <div className="flex items-center gap-2">
            <Sun className="text-orange-400" size={24} />
            <h1 className="text-xl font-bold text-gray-800">WeatherScheduler</h1>
          </div>
          <div className="flex items-center gap-4">
            <span className="text-gray-600">Welcome, {user}</span>
            <button
              onClick={onLogout}
              className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors"
            >
              Logout
            </button>
          </div>
        </div>
      </div>

      <div className="max-w-4xl mx-auto p-4 mt-6">
        {/* Weather Card */}
        <div className="bg-white rounded-xl shadow-lg p-6 mb-6">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h2 className="text-2xl font-bold text-gray-800">{weather.location}</h2>
              <p className="text-gray-600">{weather.condition}</p>
            </div>
            <div className="text-right">
              <div className="text-4xl font-bold text-gray-800">{weather.temperature}</div>
              <Cloud className="text-blue-400 mx-auto mt-2" size={32} />
            </div>
          </div>
          
          <div className="grid grid-cols-3 gap-4 mt-4">
            {weather.forecast.map((day, index) => (
              <div key={index} className="text-center p-3 bg-gray-50 rounded-lg">
                <div className="font-medium text-gray-800">{day.day}</div>
                <div className="text-sm text-gray-600">{day.condition}</div>
                <div className="text-sm font-bold text-gray-800">{day.high}°/{day.low}°</div>
              </div>
            ))}
          </div>
        </div>

        {/* Schedule Card */}
        <div className="bg-white rounded-xl shadow-lg p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-xl font-bold text-gray-800">Today's Schedule</h3>
            <Calendar className="text-gray-600" size={24} />
          </div>
          
          <div className="space-y-3">
            {events.map((event) => (
              <div key={event.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div>
                  <div className="font-medium text-gray-800">{event.title}</div>
                  <div className="text-sm text-gray-600">{event.time}</div>
                </div>
                <div className="text-sm text-gray-600 bg-blue-100 px-2 py-1 rounded">
                  {event.weather}
                </div>
              </div>
            ))}
          </div>
          
          <button className="w-full mt-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors">
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