import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';

// Stylesheets — order matters: tokens → keyframes → base → components → pages
import './styles/variables.css';
import './styles/animations.css';
import './styles/globals.css';
import './styles/components.css';
import './styles/pages.css';

import App from './App.jsx';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </StrictMode>
);
