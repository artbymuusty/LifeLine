// ==========================================================================
// LifeLine Static PWA Demo - Application Logic
// ==========================================================================

// Global Stateful Variables
const state = {
  currentScreen: 'login',
  isLoggedIn: false,
  selectedKit: 'deprem',
  logs: [
    { text: '[SYSTEM] LifeLine Server initialized on port 3000.', type: 'sys' },
    { text: '[SYSTEM] Mock database emulation active. Skipping MSSQL setup.', type: 'sys' },
    { text: '[SYSTEM] Waiting for client connections...', type: 'sys' }
  ],
  customItems: [
    'Kronik Astım İlaçları',
    'Şarj Cihazı & Powerbank',
    'Nakit Para ve Evrak Dosyası',
    'Yedek Reçeteli Gözlük'
  ]
};

// DOM Elements Mappings
const elements = {
  screens: {
    login: document.getElementById('screen-login'),
    home: document.getElementById('screen-home'),
    profile: document.getElementById('screen-profile'),
    kit: document.getElementById('screen-kit'),
    logs: document.getElementById('screen-logs')
  },
  inputs: {
    tc: document.getElementById('tc-input'),
    pwd: document.getElementById('pwd-input'),
    profName: document.getElementById('prof-name'),
    profPhone: document.getElementById('prof-phone'),
    profEmail: document.getElementById('prof-email'),
    customItem: document.getElementById('txt-custom-item')
  },
  buttons: {
    login: document.getElementById('btn-login'),
    demoLogin: document.getElementById('btn-demo-login'),
    emergency: document.getElementById('btn-emergency-trigger'),
    saveProfile: document.getElementById('btn-save-profile'),
    addCustomItem: document.getElementById('btn-add-custom-item'),
    clearLogs: document.getElementById('btn-clear-logs'),
    closeSuccess: document.getElementById('btn-success-close')
  },
  overlays: {
    success: document.getElementById('success-overlay'),
    loading: document.getElementById('loading-overlay')
  },
  nav: document.getElementById('main-nav'),
  terminal: document.getElementById('terminal-content'),
  selectedKitLabel: document.getElementById('txt-selected-kit'),
  customItemsWrapper: document.getElementById('custom-items-wrapper')
};

// ==========================================================================
// Service Worker Registration for PWA Standalone Support
// ==========================================================================
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('service-worker.js')
      .then(reg => console.log('Service Worker successfully registered with scope: ', reg.scope))
      .catch(err => console.error('Service Worker registration failed: ', err));
  });
}

// ==========================================================================
// Stateful Screen Router
// ==========================================================================
function showScreen(screenName) {
  if (!elements.screens[screenName]) return;

  // Toggle active class on screen view containers
  Object.keys(elements.screens).forEach(key => {
    elements.screens[key].classList.remove('active');
  });
  elements.screens[screenName].classList.add('active');
  state.currentScreen = screenName;

  // Hide bottom navigation if on Login Screen
  if (screenName === 'login') {
    elements.nav.style.display = 'none';
  } else {
    elements.nav.style.display = 'flex';
    
    // Set active class on navbar items
    const navItems = elements.nav.querySelectorAll('.nav-item');
    navItems.forEach(item => {
      item.classList.remove('active');
      if (item.getAttribute('data-screen') === screenName) {
        item.classList.add('active');
      }
    });

    // Generate standard API load logs on tab switch
    if (screenName === 'profile') {
      addLog('[DEMO] GET /user/profile - profile returned', 'success');
      addLog('  fullName: "Mustafa Özcan", role: "responder"', 'info');
    } else if (screenName === 'logs') {
      // Just render terminal
      renderLogs();
    }
  }
}

// ==========================================================================
// Simulated Logger Console
// ==========================================================================
function addLog(text, type = 'info') {
  const timestamp = new Date().toLocaleTimeString();
  state.logs.push({ text: `[${timestamp}] ${text}`, type });
  renderLogs();
}

function renderLogs() {
  if (!elements.terminal) return;
  
  elements.terminal.innerHTML = '';
  state.logs.forEach(log => {
    const span = document.createElement('span');
    span.textContent = log.text + '\n';
    
    // Apply visual terminal highlight colors
    if (log.type === 'success') {
      span.style.color = '#10b981'; // Green
    } else if (log.type === 'error') {
      span.style.color = '#ef4444'; // Red
    } else if (log.type === 'sys') {
      span.style.color = '#e2e8f0'; // White
    } else if (log.type === 'info') {
      span.style.color = '#38bdf8'; // Blue
    } else if (log.type === 'warn') {
      span.style.color = '#fbbf24'; // Yellow
    }
    elements.terminal.appendChild(span);
  });

  // Scroll to bottom of terminal box
  elements.terminal.scrollTop = elements.terminal.scrollHeight;
}

// ==========================================================================
// Authentication Controller Logic
// ==========================================================================
function performLogin(tc, pwd) {
  if (!tc || !pwd) {
    alert('Lütfen TC Kimlik No ve Şifre alanlarını doldurun.');
    return;
  }

  // Pre-configured static demo credentials validation
  if (tc === '11111111111' && pwd === 'demo123') {
    state.isLoggedIn = true;
    
    // Add realistic backend server request & token issuance logs
    addLog('[DEMO] POST /auth/login - login request incoming', 'warn');
    addLog('[DEMO] POST /auth/login - demo login successful', 'success');
    addLog('  Token: Issued Bearer JWT (expires: 24h)', 'info');
    addLog('  Payload: { userId: 1, role: "responder", fullName: "Mustafa Özcan" }', 'info');
    
    showScreen('home');
  } else {
    addLog(`[DEMO] POST /auth/login - failed (tc: ${tc})`, 'error');
    alert('Geçersiz TC veya Şifre (Demo için TC: 11111111111, Şifre: demo123 kullanın).');
  }
}

// ==========================================================================
// Emergency Help Sinyal Request
// ==========================================================================
function triggerEmergencyCall() {
  // Show spinner loading overlay
  elements.overlays.loading.classList.add('active');
  
  addLog('[DEMO] POST /help_requests - emergency trigger dispatched', 'warn');

  // Simulated GPS resolution & API request network lag (1200ms)
  setTimeout(() => {
    elements.overlays.loading.classList.remove('active');
    
    // Add simulated REST API transaction logs
    addLog('[DEMO] POST /help_requests - help request received', 'success');
    addLog('  userId:             1 (Mustafa Özcan)', 'info');
    addLog(`  kitType:            "${state.selectedKit}"`, 'info');
    addLog('  lat:                37.421996', 'info');
    addLog('  lng:                -122.084058', 'info');
    addLog(`  selectedItemsCount: ${state.selectedKit === 'deprem' ? 9 : state.selectedKit === 'sel' ? 5 : state.customItems.length}`, 'info');
    addLog('  status:             "received" (Rescue Teams Dispatched)', 'success');

    // Trigger success overlay screen
    elements.overlays.success.classList.add('active');
  }, 1200);
}

// ==========================================================================
// Profile Management Logic
// ==========================================================================
function saveProfile() {
  const newName = elements.inputs.profName.value.trim();
  const newPhone = elements.inputs.profPhone.value.trim();
  const newEmail = elements.inputs.profEmail.value.trim();

  if (!newName || !newPhone || !newEmail) {
    alert('Tüm alanları doldurmalısınız.');
    return;
  }

  // Update mock UI header user profile name
  document.querySelector('.header-user-info h3').textContent = newName;
  
  // Log simulated REST transactions
  addLog('[DEMO] PUT /user/profile - profile update incoming', 'warn');
  addLog('[DEMO] PUT /user/profile - profile updated', 'success');
  addLog(`  name:  "${newName}"`, 'info');
  addLog(`  phone: "${newPhone}"`, 'info');
  addLog(`  email: "${newEmail}"`, 'info');

  alert('Profil bilgileriniz başarıyla güncellendi!');
}

// ==========================================================================
// Kit Management Logic
// ==========================================================================
function renderCustomItems() {
  if (!elements.customItemsWrapper) return;

  elements.customItemsWrapper.innerHTML = '';
  state.customItems.forEach((item, index) => {
    const label = document.createElement('label');
    label.className = 'checkbox-item';
    label.innerHTML = `<input type="checkbox" checked> <span>${item}</span>`;
    
    // Add checkbox toggle listener
    label.querySelector('input').addEventListener('change', () => {
      addLog(`[DEMO] Custom Kit - item "${item}" toggled`, 'info');
    });
    
    elements.customItemsWrapper.appendChild(label);
  });
}

function selectKit(kitType) {
  state.selectedKit = kitType;
  
  // Segment buttons visually update
  const segmentBtns = document.querySelectorAll('.segment-btn');
  segmentBtns.forEach(btn => {
    btn.classList.remove('active');
    if (btn.getAttribute('data-kit') === kitType) {
      btn.classList.add('active');
    }
  });

  // Toggle visible inventory panels
  document.getElementById('list-deprem').classList.add('hidden');
  document.getElementById('list-sel').classList.add('hidden');
  document.getElementById('list-ozel').classList.add('hidden');

  if (kitType === 'deprem') {
    document.getElementById('list-deprem').classList.remove('hidden');
    elements.selectedKitLabel.textContent = 'Seçili (Deprem)';
  } else if (kitType === 'sel') {
    document.getElementById('list-sel').classList.remove('hidden');
    elements.selectedKitLabel.textContent = 'Seçili (Sel)';
  } else if (kitType === 'ozel') {
    document.getElementById('list-ozel').classList.remove('hidden');
    elements.selectedKitLabel.textContent = 'Seçili (Özel)';
  }

  addLog(`[DEMO] Active emergency bag selected: "${kitType}"`, 'info');
}

// ==========================================================================
// Event Listeners Mappings
// ==========================================================================
function setupEventListeners() {
  
  // 1. Regular Login Button Action
  elements.buttons.login.addEventListener('click', () => {
    const tcVal = elements.inputs.tc.value.trim();
    const pwdVal = elements.inputs.pwd.value;
    performLogin(tcVal, pwdVal);
  });

  // 2. Demo Auto-Login Bolt Button Action
  elements.buttons.demoLogin.addEventListener('click', () => {
    elements.inputs.tc.value = '11111111111';
    elements.inputs.pwd.value = 'demo123';
    performLogin('11111111111', 'demo123');
  });

  // 3. Bottom Bar Navigation Tab Buttons Action
  elements.nav.addEventListener('click', (event) => {
    const button = event.target.closest('.nav-item');
    if (!button) return;
    const targetScreen = button.getAttribute('data-screen');
    showScreen(targetScreen);
  });

  // 4. Pulsing Alert Button Trigger
  elements.buttons.emergency.addEventListener('click', triggerEmergencyCall);

  // 5. Close Success Screen Button Action
  elements.buttons.closeSuccess.addEventListener('click', () => {
    elements.overlays.success.classList.remove('active');
    showScreen('home');
  });

  // 6. Profile Edit Save Action
  elements.buttons.saveProfile.addEventListener('click', saveProfile);

  // 7. Segmented Control Switch Actions
  const segmentBtns = document.querySelectorAll('.segment-btn');
  segmentBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      const kitType = btn.getAttribute('data-kit');
      selectKit(kitType);
    });
  });

  // 8. Custom bag item adding action
  elements.buttons.addCustomItem.addEventListener('click', () => {
    const itemText = elements.inputs.customItem.value.trim();
    if (!itemText) return;

    state.customItems.push(itemText);
    renderCustomItems();
    elements.inputs.customItem.value = '';

    addLog(`[DEMO] Custom Kit - item "${itemText}" added to local inventory`, 'success');
  });

  // Support hitting Enter inside Custom Item input
  elements.inputs.customItem.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
      elements.buttons.addCustomItem.click();
    }
  });

  // 9. Clear simulated console logs action
  elements.buttons.clearLogs.addEventListener('click', () => {
    state.logs = [
      { text: '[SYSTEM] Logs cleared by user.', type: 'sys' }
    ];
    renderLogs();
  });
}

// ==========================================================================
// Application Bootstrap Entrypoint
// ==========================================================================
document.addEventListener('DOMContentLoaded', () => {
  setupEventListeners();
  renderCustomItems();
  
  // Hide Navbar initially
  elements.nav.style.display = 'none';
  
  // Render initial console logs
  renderLogs();
});
