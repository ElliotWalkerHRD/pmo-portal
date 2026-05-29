$path = "c:\Users\ElliotWalker\Documents\pmo-portal\index.html"
$raw = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
$isCRLF = $raw.Contains("`r`n")
$c = $raw.Replace("`r`n", "`n")

# ===== 1. CSS: team-tile expand hint =====
$oldCSS = @'
  .card-hover:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 24px rgba(105,65,198,0.08);
  }
'@
$oldCSS = $oldCSS.Replace("`r`n","`n")
$newCSS = @'
  .card-hover:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 24px rgba(105,65,198,0.08);
  }
  .team-tile::after {
    content: '▼  expand';
    display: block;
    text-align: center;
    font-size: 9px;
    color: var(--very-muted);
    margin-top: 8px;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    transition: color 0.15s;
  }
  .team-tile:hover::after { color: var(--purple); }
'@
$newCSS = $newCSS.Replace("`r`n","`n")
if ($c.Contains($oldCSS)) {
  $c = $c.Replace($oldCSS, $newCSS)
  Write-Host "✓ CSS expand hint added"
} else { Write-Host "✗ CSS anchor not found" }

# ===== 2. Bottom grid: grid-3 → grid-4 =====
$oldGrid = 'class="grid-3" style="gap:10px;margin-top:10px;" id="team-grid-bottom"'
$newGrid = 'class="grid-4" style="gap:10px;margin-top:10px;" id="team-grid-bottom"'
if ($c.Contains($oldGrid)) {
  $c = $c.Replace($oldGrid, $newGrid)
  Write-Host "✓ Bottom grid changed to grid-4"
} else { Write-Host "✗ Bottom grid anchor not found" }

# ===== 3. Add Strategy & Assurance tile to bottom grid =====
$oldMktgEnd = @'
          <div style="text-align:center;margin-top:6px;"><div class="pill" style="background:#FEF3F2;color:#F04438;"><span class="pill-dot"></span>Justine</div></div>
        </div>
      </div>
'@
$oldMktgEnd = $oldMktgEnd.Replace("`r`n","`n")
$newMktgEnd = @'
          <div style="text-align:center;margin-top:6px;"><div class="pill" style="background:#FEF3F2;color:#F04438;"><span class="pill-dot"></span>Justine</div></div>
        </div>
        <div class="card card-hover team-tile" style="padding:18px;cursor:pointer;" onclick="toggleTeamDetail('strategy')">
          <div style="display:flex;justify-content:center;margin-bottom:8px;"><div class="icon-circle icon-circle-lg" style="background:#F0FDF4;border-color:#A3E0B0;"><svg style="stroke:#059669;"><use href="#i-shield"/></svg></div></div>
          <div class="item-title" style="font-size:14px;text-align:center;">Strategy &amp; Assurance</div>
          <div class="item-desc" style="text-align:center;margin-top:4px;font-size:11px;">Strategic initiatives and delivery assurance.</div>
          <div style="text-align:center;margin-top:6px;"><div class="pill" style="background:#F0FDF4;color:#059669;border:1px solid #A3E0B0;"><span class="pill-dot"></span>Julie, James</div></div>
        </div>
      </div>
'@
$newMktgEnd = $newMktgEnd.Replace("`r`n","`n")
if ($c.Contains($oldMktgEnd)) {
  $c = $c.Replace($oldMktgEnd, $newMktgEnd)
  Write-Host "✓ Strategy & Assurance tile added"
} else { Write-Host "✗ Marketing tile end anchor not found" }

# ===== 4. Add detail-strategy panel (before <!-- VIDEOS -->) =====
$detailStrategyPanel = @'

      <div id="detail-strategy" class="team-detail" style="display:none;margin:10px 0;">
        <div class="card" style="padding:24px;border-left:4px solid #059669;">
          <div style="font-weight:800;font-size:16px;color:var(--heading);margin-bottom:14px;">Strategy &amp; Assurance</div>
          <div style="display:flex;gap:20px;margin-bottom:14px;flex-wrap:wrap;">
            <div style="display:flex;align-items:center;gap:10px;">
              <img src="https://avatars.slack-edge.com/2023-06-14/5422396896630_18310f9bbfdb1ccd2f9e_72.png" style="width:72px;height:72px;border-radius:16px;object-fit:cover;border:2px solid rgba(139,92,246,0.15);">
              <div><div style="font-weight:700;font-size:12px;color:var(--heading);">Julie Cokotis</div><div style="font-size:10px;color:var(--muted);">Senior Director</div></div>
            </div>
            <div style="display:flex;align-items:center;gap:10px;">
              <img src="https://avatars.slack-edge.com/2026-03-09/10675139248017_272f38a10c087372d3ff_72.png" style="width:72px;height:72px;border-radius:16px;object-fit:cover;border:2px solid rgba(139,92,246,0.15);">
              <div><div style="font-weight:700;font-size:12px;color:var(--heading);">James Hirst</div><div style="font-size:10px;color:var(--muted);">Senior Director</div></div>
            </div>
          </div>
          <div id="ttile-assurance-dynamic" style="margin-top:8px;"></div>
          <div style="display:flex;justify-content:flex-end;margin-top:10px;">
            <button class="btn-edit-team" onclick="editTeamTile('assurance')">&#9998; Edit</button>
          </div>
          <div id="ttile-assurance-editform" style="display:none;margin-top:12px;border-top:1px solid var(--divider);padding-top:14px;">
            <div class="tspace-section-label">What we do</div>
            <textarea id="ttile-assurance-wedo" class="modal-input" style="min-height:60px;resize:vertical;margin-bottom:12px;" placeholder="One item per line..."></textarea>
            <div class="tspace-section-label">What we don&#39;t do</div>
            <textarea id="ttile-assurance-wdont" class="modal-input" style="min-height:60px;resize:vertical;margin-bottom:12px;" placeholder="One item per line..."></textarea>
            <div class="tspace-section-label">How to engage us</div>
            <textarea id="ttile-assurance-engage" class="modal-input" style="min-height:40px;resize:vertical;margin-bottom:12px;" placeholder="How should people reach out?"></textarea>
            <div class="tspace-section-label">Useful links</div>
            <div id="ttile-assurance-links-edit" style="margin-bottom:6px;"></div>
            <button onclick="addTeamTileLink('assurance')" style="font-size:10px;font-weight:700;color:var(--purple);background:none;border:none;cursor:pointer;padding:2px 0;font-family:inherit;margin-bottom:12px;">+ Add link</button>
            <div class="tspace-section-label">Notes</div>
            <textarea id="ttile-assurance-notes-edit" class="modal-input" style="min-height:40px;resize:vertical;margin-bottom:12px;" placeholder="Additional context..."></textarea>
            <div style="display:flex;gap:8px;">
              <button onclick="cancelTeamTileEdit('assurance')" style="flex:1;padding:7px;border:1px solid var(--divider);border-radius:var(--radius-sm);background:var(--card-bg);color:var(--muted);font-size:12px;font-weight:700;cursor:pointer;font-family:inherit;">Cancel</button>
              <button onclick="saveTeamTile('assurance')" style="flex:1;padding:7px;border:none;border-radius:var(--radius-sm);background:var(--purple);color:#fff;font-size:12px;font-weight:700;cursor:pointer;font-family:inherit;">Save</button>
            </div>
          </div>
        </div>
      </div>
'@
$detailStrategyPanel = $detailStrategyPanel.Replace("`r`n","`n")
# Insert before the section-wrapper close and VIDEOS comment
$videosAnchor = "`n    </div>`n`n    <div class=""section-divider""></div>`n`n    <!-- VIDEOS -->"
$si = $c.IndexOf($videosAnchor)
if ($si -ge 0) {
  $c = $c.Substring(0, $si) + $detailStrategyPanel + $c.Substring($si)
  Write-Host "✓ detail-strategy panel inserted"
} else { Write-Host "✗ VIDEOS anchor not found for detail-strategy insertion" }

# ===== 5. Imogen Weaver photo =====
$oldImogen = '<div class="avatar" style="background:#0891B2;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:28px;">IW</div>'
$newImogen = '<img src="https://avatars.slack-edge.com/2023-12-04/6289197624099_dc0cc1c7c0953792d29e_72.jpg" class="avatar" style="object-fit:cover;border:3px solid #7DD3FC;">'
if ($c.Contains($oldImogen)) {
  $c = $c.Replace($oldImogen, $newImogen)
  Write-Host "✓ Imogen Weaver photo updated"
} else { Write-Host "✗ Imogen avatar not found" }

# ===== 6. Remove Add Update button from Feed tab =====
$oldFeedHeader = @'
      <div style="display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-bottom:4px;">
        <div>
          <h2 class="section-title" style="margin-bottom:6px;">What we've been delivering</h2>
          <p class="section-subtitle">A running log of what's shipped, what's changed, and what's hit a milestone.</p>
        </div>
        <button class="add-feed-btn" onclick="openAddEntry()">+ Add update</button>
      </div>
'@
$oldFeedHeader = $oldFeedHeader.Replace("`r`n","`n")
$newFeedHeader = @'
      <h2 class="section-title" style="margin-bottom:6px;">What we've been delivering</h2>
      <p class="section-subtitle">A running log of what's shipped, what's changed, and what's hit a milestone.</p>
'@
$newFeedHeader = $newFeedHeader.Replace("`r`n","`n")
if ($c.Contains($oldFeedHeader)) {
  $c = $c.Replace($oldFeedHeader, $newFeedHeader)
  Write-Host "✓ Add update button removed from feed"
} else { Write-Host "✗ Feed header anchor not found" }

# ===== 7. Make FAQ section dynamic =====
$oldFaqAccordions = @'
      <div class="accordion" onclick="this.classList.toggle('open')">
        <div class="accordion-header"><span>How do I submit a request?</span><svg class="accordion-icon"><use href="#i-chevron"/></svg></div>
        <div class="accordion-body">Post in <a href="https://hardrockdigital.slack.com/archives/C0AU75RHXLS" target="_blank" style="color:var(--purple);font-weight:600;text-decoration:none;">#hrd-pmo</a> on Slack. A Jira ticket is created automatically. We triage within 48 hours and assign a PM if it's accepted.</div>
      </div>
      <div class="accordion" onclick="this.classList.toggle('open')">
        <div class="accordion-header"><span>What kind of work does the PMO take on?</span><svg class="accordion-icon"><use href="#i-chevron"/></svg></div>
        <div class="accordion-body">Work that crosses teams, needs dedicated project leadership, or is exec-sponsored. We don't manage team backlogs, run standups, or own product delivery.</div>
      </div>
      <div class="accordion" onclick="this.classList.toggle('open')">
        <div class="accordion-header"><span>Who decides priority?</span><svg class="accordion-icon"><use href="#i-chevron"/></svg></div>
        <div class="accordion-body">The PMO Director and VP PMO, in line with company strategic priorities. If something is urgent and cross-functional, it gets fast-tracked.</div>
      </div>
      <div class="accordion" onclick="this.classList.toggle('open')">
        <div class="accordion-header"><span>How do I work with a department team?</span><svg class="accordion-icon"><use href="#i-chevron"/></svg></div>
        <div class="accordion-body">Department directors (Casino, Tech, Data, Marketing) are embedded in your organisation. Reach out directly via Slack. No intake form needed. For cross-department work, they'll route it to Central Projects.</div>
      </div>
'@
$oldFaqAccordions = $oldFaqAccordions.Replace("`r`n","`n")
$newFaqContainer = "      <div id=""faq-dynamic-container""></div>`n"
if ($c.Contains($oldFaqAccordions)) {
  $c = $c.Replace($oldFaqAccordions, $newFaqContainer)
  Write-Host "✓ FAQ section made dynamic"
} else { Write-Host "✗ Static FAQ accordions not found" }

# ===== 8. Make carousel dots dynamic =====
$oldDots = @'
        <div style="display:flex;justify-content:center;gap:8px;margin-top:14px;">
          <div class="test-dot" onclick="goTestimonial(0)" style="width:8px;height:8px;border-radius:50%;background:var(--purple);cursor:pointer;"></div>
          <div class="test-dot" onclick="goTestimonial(1)" style="width:8px;height:8px;border-radius:50%;background:var(--divider);cursor:pointer;"></div>
          <div class="test-dot" onclick="goTestimonial(2)" style="width:8px;height:8px;border-radius:50%;background:var(--divider);cursor:pointer;"></div>
          <div class="test-dot" onclick="goTestimonial(3)" style="width:8px;height:8px;border-radius:50%;background:var(--divider);cursor:pointer;"></div>
        </div>
'@
$oldDots = $oldDots.Replace("`r`n","`n")
$newDots = "        <div id=""testimonial-dots"" style=""display:flex;justify-content:center;gap:8px;margin-top:14px;""></div>`n"
if ($c.Contains($oldDots)) {
  $c = $c.Replace($oldDots, $newDots)
  Write-Host "✓ Carousel dots made dynamic"
} else { Write-Host "✗ Carousel dots anchor not found" }

# ===== 9. Add Manage Content to admin sub-nav =====
$oldSubNav = @'
      <button class="admin-subnav-btn" onclick="switchAdminPanel('aitoolkit', this)">AI Toolkit</button>
    </div>
'@
$oldSubNav = $oldSubNav.Replace("`r`n","`n")
$newSubNav = @'
      <button class="admin-subnav-btn" onclick="switchAdminPanel('aitoolkit', this)">AI Toolkit</button>
      <button class="admin-subnav-btn" onclick="switchAdminPanel('content', this)">Manage Content</button>
    </div>
'@
$newSubNav = $newSubNav.Replace("`r`n","`n")
if ($c.Contains($oldSubNav)) {
  $c = $c.Replace($oldSubNav, $newSubNav)
  Write-Host "✓ Manage Content sub-nav button added"
} else { Write-Host "✗ Admin sub-nav anchor not found" }

# ===== 10. Add admin-panel-content panel =====
$contentPanel = @'

    <!-- ===== CONTENT MANAGEMENT PANEL ===== -->
    <div id="admin-panel-content" class="admin-subpanel">

      <!-- DELIVERY FEED -->
      <div class="section">
        <div class="section-label">Delivery Feed</div>
        <h2 class="section-title">Add a feed entry</h2>
        <p class="section-subtitle">Add updates to the public-facing delivery feed.</p>
        <div class="card" style="padding:20px;">
          <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Date</div>
          <input type="text" class="modal-input" id="admin-feed-date" placeholder="e.g. 28 May" style="margin-bottom:12px;">
          <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Title</div>
          <input type="text" class="modal-input" id="admin-feed-title" placeholder="What was delivered or achieved?" style="margin-bottom:12px;">
          <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Description</div>
          <textarea class="modal-input" id="admin-feed-desc" rows="3" placeholder="Brief summary..." style="resize:vertical;margin-bottom:12px;"></textarea>
          <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Type</div>
          <select class="modal-input" id="admin-feed-type" style="margin-bottom:18px;">
            <option value="milestone">Milestone</option>
            <option value="shipped">Shipped</option>
            <option value="process">Process</option>
            <option value="capability">New Capability</option>
          </select>
          <button onclick="submitAdminFeedEntry()" style="width:100%;padding:9px;border:none;border-radius:var(--radius-sm);background:var(--purple);color:#fff;font-size:13px;font-weight:700;cursor:pointer;font-family:inherit;">Add to Feed</button>
        </div>
      </div>

      <div class="section-divider"></div>

      <!-- FAQ -->
      <div class="section">
        <div class="section-label">FAQ</div>
        <h2 class="section-title">Manage FAQs</h2>
        <p class="section-subtitle">Add questions that appear on the home page. Optionally tag to a specific team.</p>
        <div class="card" style="padding:20px;margin-bottom:12px;">
          <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Question</div>
          <input type="text" class="modal-input" id="admin-faq-question" placeholder="What is the question?" style="margin-bottom:12px;">
          <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Answer</div>
          <textarea class="modal-input" id="admin-faq-answer" rows="3" placeholder="The answer..." style="resize:vertical;margin-bottom:12px;"></textarea>
          <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Related team (optional)</div>
          <select class="modal-input" id="admin-faq-team" style="margin-bottom:18px;">
            <option value="all">All teams</option>
            <option value="central">Central Projects</option>
            <option value="techpmo">Tech PMO</option>
            <option value="casino">Casino</option>
            <option value="international">International</option>
            <option value="marketing">Marketing</option>
            <option value="data">Data</option>
            <option value="assurance">Strategy &amp; Assurance</option>
          </select>
          <button onclick="submitAdminFaq()" style="width:100%;padding:9px;border:none;border-radius:var(--radius-sm);background:var(--purple);color:#fff;font-size:13px;font-weight:700;cursor:pointer;font-family:inherit;">Add FAQ</button>
        </div>
        <div id="admin-faq-list"></div>
      </div>

      <div class="section-divider"></div>

      <!-- IMPACT -->
      <div class="section">
        <div class="section-label">Impact</div>
        <h2 class="section-title">Add an impact story</h2>
        <p class="section-subtitle">Showcase PMO delivery. Stories appear in the Impact carousel on the home page.</p>
        <div class="card" style="padding:20px;margin-bottom:12px;">
          <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Title</div>
          <input type="text" class="modal-input" id="admin-impact-title" placeholder="Project or initiative name" style="margin-bottom:12px;">
          <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Description</div>
          <textarea class="modal-input" id="admin-impact-desc" rows="3" placeholder="What was achieved..." style="resize:vertical;margin-bottom:12px;"></textarea>
          <div style="display:flex;gap:10px;margin-bottom:12px;">
            <div style="flex:1;">
              <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Status</div>
              <select class="modal-input" id="admin-impact-status">
                <option value="shipped">Shipped</option>
                <option value="execution">In Execution</option>
                <option value="planning">In Planning</option>
              </select>
            </div>
            <div style="flex:1;">
              <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Status date</div>
              <input type="text" class="modal-input" id="admin-impact-date" placeholder="e.g. Apr 2026">
            </div>
          </div>
          <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">PMO team</div>
          <select class="modal-input" id="admin-impact-team" style="margin-bottom:12px;">
            <option value="all">All teams / PMO</option>
            <option value="central">Central Projects</option>
            <option value="techpmo">Tech PMO</option>
            <option value="casino">Casino</option>
            <option value="international">International</option>
            <option value="marketing">Marketing</option>
            <option value="data">Data</option>
            <option value="assurance">Strategy &amp; Assurance</option>
          </select>
          <div style="font-size:10px;font-weight:700;color:var(--purple);letter-spacing:1px;text-transform:uppercase;margin-bottom:8px;margin-top:8px;padding-top:12px;border-top:1px solid var(--divider);">Testimonial (optional)</div>
          <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Quote</div>
          <textarea class="modal-input" id="admin-impact-testimonial" rows="2" placeholder="Their quote..." style="resize:vertical;margin-bottom:12px;"></textarea>
          <div style="display:flex;gap:10px;margin-bottom:18px;">
            <div style="flex:1;">
              <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Author name</div>
              <input type="text" class="modal-input" id="admin-impact-author" placeholder="Name">
            </div>
            <div style="flex:1;">
              <div style="font-size:10px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:5px;">Author role</div>
              <input type="text" class="modal-input" id="admin-impact-role" placeholder="e.g. VP Operations">
            </div>
          </div>
          <button onclick="submitAdminImpact()" style="width:100%;padding:9px;border:none;border-radius:var(--radius-sm);background:var(--purple);color:#fff;font-size:13px;font-weight:700;cursor:pointer;font-family:inherit;">Add Impact Story</button>
        </div>
        <div id="admin-impact-list"></div>
      </div>

    </div><!-- close content panel -->
'@
$contentPanel = $contentPanel.Replace("`r`n","`n")
$oldAdminClose = "    </div><!-- close aitoolkit panel -->`n  </div><!-- close admin tab -->"
$newAdminClose = "    </div><!-- close aitoolkit panel -->" + $contentPanel + "`n  </div><!-- close admin tab -->"
if ($c.Contains($oldAdminClose)) {
  $c = $c.Replace($oldAdminClose, $newAdminClose)
  Write-Host "✓ admin-panel-content added"
} else { Write-Host "✗ Admin close anchor not found" }

# ===== 11. Modify switchTab for admin PIN gate =====
$oldSwitchTab = @'
function switchTab(tabId, btn) {
  document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
  document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
  const tab = document.getElementById('tab-' + tabId);
  if (tab) tab.classList.add('active');
  if (btn) btn.classList.add('active');
  window.scrollTo({ top: 0, behavior: 'smooth' });
  requestAnimationFrame(() => {
    document.querySelectorAll('#tab-' + tabId + ' .fade-in').forEach(el => el.classList.add('visible'));
  });
}
'@
$oldSwitchTab = $oldSwitchTab.Replace("`r`n","`n")
$newSwitchTab = @'
let adminUnlocked = false;
let pendingAdminBtn = null;

function doSwitchTab(tabId, btn) {
  document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
  document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
  const tab = document.getElementById('tab-' + tabId);
  if (tab) tab.classList.add('active');
  if (btn) btn.classList.add('active');
  window.scrollTo({ top: 0, behavior: 'smooth' });
  requestAnimationFrame(() => {
    document.querySelectorAll('#tab-' + tabId + ' .fade-in').forEach(el => el.classList.add('visible'));
  });
}

function switchTab(tabId, btn) {
  if (tabId === 'admin' && !adminUnlocked) {
    pendingAdminBtn = btn;
    pinContext = { type: 'admin' };
    document.getElementById('modal-pin-title').textContent = 'PMO Team Only';
    document.getElementById('modal-pin-subtitle').textContent = 'Enter the PMO admin PIN to access this area.';
    openPinModal();
    return;
  }
  doSwitchTab(tabId, btn);
}
'@
$newSwitchTab = $newSwitchTab.Replace("`r`n","`n")
if ($c.Contains($oldSwitchTab)) {
  $c = $c.Replace($oldSwitchTab, $newSwitchTab)
  Write-Host "✓ switchTab modified for admin PIN gate"
} else { Write-Host "✗ switchTab anchor not found" }

# ===== 12. Add admin PIN and update PMO_PINS =====
$oldPins = "const PMO_PINS = {`n  central: '1111', techpmo: '2222', casino: '3333', international: '4444',`n  marketing: '5555', data: '6666', assurance: '7777', feed: '0000'`n};"
$newPins = "const PMO_PINS = {`n  central: '1111', techpmo: '2222', casino: '3333', international: '4444',`n  marketing: '5555', data: '6666', assurance: '7777', feed: '0000', admin: '0000'`n};"
if ($c.Contains($oldPins)) {
  $c = $c.Replace($oldPins, $newPins)
  Write-Host "✓ PMO_PINS updated with admin PIN"
} else { Write-Host "✗ PMO_PINS anchor not found" }

# ===== 13. Add admin type to submitPin dispatch =====
$oldSubmitPinDispatch = "  else if (ctx.type === 'person') { showPersonEditForm(ctx.slug); }"
$newSubmitPinDispatch = "  else if (ctx.type === 'person') { showPersonEditForm(ctx.slug); }`n  else if (ctx.type === 'admin') { adminUnlocked = true; var aBtn = pendingAdminBtn; pendingAdminBtn = null; doSwitchTab('admin', aBtn); }"
if ($c.Contains($oldSubmitPinDispatch)) {
  $c = $c.Replace($oldSubmitPinDispatch, $newSubmitPinDispatch)
  Write-Host "✓ submitPin updated with admin dispatch"
} else { Write-Host "✗ submitPin dispatch anchor not found" }

# ===== 14. Update submitPin key lookup for admin =====
$oldKeyLookup = "  var key = pinContext.type === 'feed' ? 'feed' : (pinContext.type === 'person' ? pinContext.teamId : pinContext.id);"
$newKeyLookup = "  var key = pinContext.type === 'feed' ? 'feed' : (pinContext.type === 'admin' ? 'admin' : (pinContext.type === 'person' ? pinContext.teamId : pinContext.id));"
if ($c.Contains($oldKeyLookup)) {
  $c = $c.Replace($oldKeyLookup, $newKeyLookup)
  Write-Host "✓ submitPin key lookup updated"
} else { Write-Host "✗ submitPin key lookup anchor not found" }

# ===== 15. Update carousel setInterval for dynamic count =====
$oldInterval = "setInterval(() => { goTestimonial((testSlide + 1) % 4); }, 6000);"
$newInterval = "function getTotalSlides() { var t = document.getElementById('testimonial-track'); return t ? t.children.length : 4; }`nsetInterval(() => { var total = getTotalSlides(); if (total > 0) goTestimonial((testSlide + 1) % total); }, 6000);"
if ($c.Contains($oldInterval)) {
  $c = $c.Replace($oldInterval, $newInterval)
  Write-Host "✓ Carousel setInterval updated"
} else { Write-Host "✗ Carousel setInterval not found" }

# ===== 16. Add new JS functions before '// Init on load' =====
$newJSFunctions = @'

// ======================== TEAM / FAQ / IMPACT HELPERS ========================

const TEAM_LABELS = {
  all: 'All teams', central: 'Central Projects', techpmo: 'Tech PMO',
  casino: 'Casino', international: 'International', marketing: 'Marketing',
  data: 'Data', assurance: 'Strategy & Assurance'
};
const TEAM_COLORS = {
  all:           { bg: '#F4F3FF', color: '#6941C6', border: '#E9D7FE' },
  central:       { bg: '#F4F3FF', color: '#6941C6', border: '#E9D7FE' },
  techpmo:       { bg: '#FFF3E0', color: '#DC6803', border: '#FDD9A3' },
  casino:        { bg: '#EDE9FE', color: '#7C3AED', border: '#C4B5FD' },
  international: { bg: '#EFF8FF', color: '#2563EB', border: '#B2DDFF' },
  marketing:     { bg: '#FEF3F2', color: '#F04438', border: '#FECDCA' },
  data:          { bg: '#E0F2FE', color: '#0891B2', border: '#7DD3FC' },
  assurance:     { bg: '#F0FDF4', color: '#059669', border: '#A3E0B0' }
};

function teamBadgeHtml(team) {
  if (!team || team === 'all') return '';
  var t = TEAM_COLORS[team] || TEAM_COLORS.central;
  var label = TEAM_LABELS[team] || team;
  return '<span style="background:' + t.bg + ';color:' + t.color + ';border:1px solid ' + t.border + ';padding:2px 8px;border-radius:100px;font-size:9px;font-weight:700;vertical-align:middle;margin-left:6px;">' + escHtml(label) + '</span>';
}

// ======================== FAQ ========================

function loadFaqEntries() {
  try { return JSON.parse(localStorage.getItem('pmo_faq_entries') || '[]'); } catch(e) { return []; }
}
function saveFaqEntries(entries) { localStorage.setItem('pmo_faq_entries', JSON.stringify(entries)); }

function deleteFaqEntry(id) {
  saveFaqEntries(loadFaqEntries().filter(function(e) { return e.id !== id; }));
  renderFaqEntries();
  renderAdminFaqList();
}

function renderFaqEntries() {
  var container = document.getElementById('faq-dynamic-container');
  if (!container) return;
  var entries = loadFaqEntries();
  if (!entries.length) {
    container.innerHTML = '<div style="font-size:12px;color:var(--muted);padding:8px 0;font-style:italic;">No FAQs yet.</div>';
    return;
  }
  var html = '';
  entries.forEach(function(e) {
    html += '<div class="accordion" onclick="this.classList.toggle(\'open\')" style="margin-bottom:6px;">' +
      '<div class="accordion-header"><span>' + escHtml(e.question) + '</span>' + teamBadgeHtml(e.team) +
        '<svg class="accordion-icon"><use href="#i-chevron"/></svg>' +
      '</div>' +
      '<div class="accordion-body">' + escHtml(e.answer) + '</div>' +
    '</div>';
  });
  container.innerHTML = html;
}

function renderAdminFaqList() {
  var el = document.getElementById('admin-faq-list');
  if (!el) return;
  var entries = loadFaqEntries();
  if (!entries.length) { el.innerHTML = '<div style="font-size:11px;color:var(--very-muted);font-style:italic;padding:8px 0;">No FAQs added yet.</div>'; return; }
  var html = '';
  entries.forEach(function(e) {
    var t = TEAM_COLORS[e.team] || TEAM_COLORS.all;
    var label = TEAM_LABELS[e.team] || 'All';
    html += '<div style="display:flex;align-items:flex-start;justify-content:space-between;padding:10px 14px;background:var(--card-bg);border:1px solid var(--divider);border-radius:var(--radius-sm);margin-bottom:6px;">' +
      '<div style="flex:1;min-width:0;">' +
        '<div style="font-weight:700;font-size:12px;color:var(--heading);margin-bottom:2px;">' + escHtml(e.question) + '</div>' +
        '<div style="font-size:11px;color:var(--muted);line-height:1.5;margin-bottom:4px;">' + escHtml(e.answer) + '</div>' +
        '<span style="background:' + t.bg + ';color:' + t.color + ';border:1px solid ' + t.border + ';padding:2px 8px;border-radius:100px;font-size:9px;font-weight:700;">' + escHtml(label) + '</span>' +
      '</div>' +
      '<button onclick="deleteFaqEntry(' + e.id + ')" style="margin-left:10px;padding:4px 8px;border:1px solid var(--divider);border-radius:var(--radius-sm);background:none;cursor:pointer;color:var(--muted);font-size:11px;font-family:inherit;flex-shrink:0;">&#215; Delete</button>' +
    '</div>';
  });
  el.innerHTML = html;
}

function submitAdminFaq() {
  var q = document.getElementById('admin-faq-question').value.trim();
  var a = document.getElementById('admin-faq-answer').value.trim();
  var team = document.getElementById('admin-faq-team').value;
  if (!q || !a) { alert('Question and answer are required.'); return; }
  var entries = loadFaqEntries();
  entries.unshift({ id: Date.now(), question: q, answer: a, team: team });
  saveFaqEntries(entries);
  document.getElementById('admin-faq-question').value = '';
  document.getElementById('admin-faq-answer').value = '';
  document.getElementById('admin-faq-team').value = 'all';
  renderFaqEntries();
  renderAdminFaqList();
}

// ======================== IMPACT ========================

function loadImpactEntries() {
  try { return JSON.parse(localStorage.getItem('pmo_impact_entries') || '[]'); } catch(e) { return []; }
}
function saveImpactEntries(entries) { localStorage.setItem('pmo_impact_entries', JSON.stringify(entries)); }

function deleteImpactEntry(id) {
  saveImpactEntries(loadImpactEntries().filter(function(e) { return e.id !== id; }));
  renderImpactEntries();
  renderAdminImpactList();
}

var IMPACT_STATUS_CONFIG = {
  shipped:   { cls: 'feed-tag-shipped',   label: 'Shipped' },
  execution: { cls: 'feed-tag-milestone', label: 'In Execution' },
  planning:  { cls: 'feed-tag-process',   label: 'In Planning' }
};

function renderImpactEntries() {
  var track = document.getElementById('testimonial-track');
  var dotsContainer = document.getElementById('testimonial-dots');
  if (!track || !dotsContainer) return;
  // Remove previously injected dynamic slides
  track.querySelectorAll('.dynamic-impact-slide').forEach(function(e) { e.remove(); });
  var entries = loadImpactEntries();
  entries.forEach(function(e) {
    var slide = document.createElement('div');
    slide.className = 'dynamic-impact-slide';
    slide.style.minWidth = '100%';
    slide.style.paddingRight = '20px';
    var statusCfg = IMPACT_STATUS_CONFIG[e.status] || IMPACT_STATUS_CONFIG.shipped;
    var tc = TEAM_COLORS[e.team] || TEAM_COLORS.all;
    var teamBadge = (e.team && e.team !== 'all') ? '<span style="background:' + tc.bg + ';color:' + tc.color + ';border:1px solid ' + tc.border + ';padding:2px 8px;border-radius:100px;font-size:9px;font-weight:700;margin-left:6px;">' + escHtml(TEAM_LABELS[e.team] || e.team) + '</span>' : '';
    var testimonialHtml = e.testimonial ? '<div style="border-left:3px solid var(--purple);padding:10px 14px;background:var(--purple-bg);border-radius:0 8px 8px 0;">' +
      '<p style="font-size:11px;color:var(--heading);line-height:1.6;font-style:italic;margin-bottom:6px;">"' + escHtml(e.testimonial) + '"</p>' +
      (e.testimonialAuthor ? '<div style="font-weight:700;font-size:11px;color:var(--purple);">' + escHtml(e.testimonialAuthor) + '</div>' : '') +
      (e.testimonialRole ? '<div style="font-size:10px;color:var(--muted);">' + escHtml(e.testimonialRole) + '</div>' : '') +
      '</div>' : '';
    slide.innerHTML = '<div class="card" style="padding:20px;margin:0;">' +
      '<div style="display:flex;gap:6px;margin-bottom:8px;align-items:center;">' +
        '<span class="feed-tag ' + statusCfg.cls + '">' + statusCfg.label + '</span>' + teamBadge +
        (e.statusDate ? '<span style="font-size:10px;color:var(--muted);padding:2px 0;">' + escHtml(e.statusDate) + '</span>' : '') +
      '</div>' +
      '<div style="font-weight:800;font-size:15px;color:var(--heading);margin-bottom:6px;">' + escHtml(e.title) + '</div>' +
      (e.description ? '<div style="font-size:11px;color:var(--body);line-height:1.6;margin-bottom:12px;">' + escHtml(e.description) + '</div>' : '') +
      testimonialHtml +
    '</div>';
    track.appendChild(slide);
  });
  // Rebuild dots
  var total = track.children.length;
  var dotsHtml = '';
  for (var i = 0; i < total; i++) {
    dotsHtml += '<div class="test-dot" onclick="goTestimonial(' + i + ')" style="width:8px;height:8px;border-radius:50%;background:' + (i === 0 ? 'var(--purple)' : 'var(--divider)') + ';cursor:pointer;"></div>';
  }
  dotsContainer.innerHTML = dotsHtml;
  if (testSlide >= total && total > 0) goTestimonial(0);
}

function renderAdminImpactList() {
  var el = document.getElementById('admin-impact-list');
  if (!el) return;
  var entries = loadImpactEntries();
  if (!entries.length) { el.innerHTML = '<div style="font-size:11px;color:var(--very-muted);font-style:italic;padding:8px 0;">No impact stories added yet.</div>'; return; }
  var html = '';
  entries.forEach(function(e) {
    html += '<div style="display:flex;align-items:flex-start;justify-content:space-between;padding:10px 14px;background:var(--card-bg);border:1px solid var(--divider);border-radius:var(--radius-sm);margin-bottom:6px;">' +
      '<div style="flex:1;min-width:0;">' +
        '<div style="font-weight:700;font-size:12px;color:var(--heading);margin-bottom:2px;">' + escHtml(e.title) + '</div>' +
        (e.description ? '<div style="font-size:11px;color:var(--muted);line-height:1.5;margin-bottom:2px;">' + escHtml(e.description.substring(0, 80)) + (e.description.length > 80 ? '...' : '') + '</div>' : '') +
        (e.testimonialAuthor ? '<div style="font-size:10px;color:var(--very-muted);font-style:italic;">"' + escHtml((e.testimonial||'').substring(0,60)) + '..." — ' + escHtml(e.testimonialAuthor) + '</div>' : '') +
      '</div>' +
      '<button onclick="deleteImpactEntry(' + e.id + ')" style="margin-left:10px;padding:4px 8px;border:1px solid var(--divider);border-radius:var(--radius-sm);background:none;cursor:pointer;color:var(--muted);font-size:11px;font-family:inherit;flex-shrink:0;">&#215; Delete</button>' +
    '</div>';
  });
  el.innerHTML = html;
}

function submitAdminImpact() {
  var title = document.getElementById('admin-impact-title').value.trim();
  var desc = document.getElementById('admin-impact-desc').value.trim();
  var testimonial = document.getElementById('admin-impact-testimonial').value.trim();
  var author = document.getElementById('admin-impact-author').value.trim();
  var role = document.getElementById('admin-impact-role').value.trim();
  var status = document.getElementById('admin-impact-status').value;
  var statusDate = document.getElementById('admin-impact-date').value.trim();
  var team = document.getElementById('admin-impact-team').value;
  if (!title) { alert('Title is required.'); return; }
  var entries = loadImpactEntries();
  entries.unshift({ id: Date.now(), title: title, description: desc, testimonial: testimonial, testimonialAuthor: author, testimonialRole: role, status: status, statusDate: statusDate, team: team });
  saveImpactEntries(entries);
  ['admin-impact-title','admin-impact-desc','admin-impact-testimonial','admin-impact-author','admin-impact-role','admin-impact-date'].forEach(function(id) { document.getElementById(id).value = ''; });
  document.getElementById('admin-impact-status').value = 'shipped';
  document.getElementById('admin-impact-team').value = 'all';
  renderImpactEntries();
  renderAdminImpactList();
}

function submitAdminFeedEntry() {
  var date = document.getElementById('admin-feed-date').value.trim();
  var title = document.getElementById('admin-feed-title').value.trim();
  var desc = document.getElementById('admin-feed-desc').value.trim();
  var type = document.getElementById('admin-feed-type').value;
  if (!date || !title) { alert('Date and title are required.'); return; }
  var entries = loadFeedEntries();
  entries.unshift({ date: date, title: title, desc: desc, type: type, id: Date.now() });
  localStorage.setItem('pmo_feed_entries', JSON.stringify(entries));
  document.getElementById('admin-feed-date').value = '';
  document.getElementById('admin-feed-title').value = '';
  document.getElementById('admin-feed-desc').value = '';
  renderFeedEntries();
  alert('Feed entry added!');
}

'@
$newJSFunctions = $newJSFunctions.Replace("`r`n","`n")
$initAnchor = "// Init on load"
$si2 = $c.IndexOf($initAnchor)
if ($si2 -ge 0) {
  $c = $c.Substring(0, $si2) + $newJSFunctions + $c.Substring($si2)
  Write-Host "✓ New JS functions added"
} else { Write-Host "✗ '// Init on load' anchor not found" }

# ===== 17. Update DOMContentLoaded to init FAQ, Impact, Assurance =====
$oldDOMReady = @'
  ['central','techpmo','casino','international','marketing','data','assurance'].forEach(renderTeamTile);
  // Render feed entries
  renderFeedEntries();
'@
$oldDOMReady = $oldDOMReady.Replace("`r`n","`n")
$newDOMReady = @'
  ['central','techpmo','casino','international','marketing','data','assurance'].forEach(renderTeamTile);
  // Seed FAQ entries on first load
  if (!localStorage.getItem('pmo_faq_entries')) {
    localStorage.setItem('pmo_faq_entries', JSON.stringify([
      { id: 1, question: 'How do I submit a request?', answer: 'Post in #hrd-pmo on Slack. A Jira ticket is created automatically. We triage within 48 hours and assign a PM if it\'s accepted.', team: 'all' },
      { id: 2, question: 'What kind of work does the PMO take on?', answer: 'Work that crosses teams, needs dedicated project leadership, or is exec-sponsored. We don\'t manage team backlogs, run standups, or own product delivery.', team: 'all' },
      { id: 3, question: 'Who decides priority?', answer: 'The PMO Director and VP PMO, in line with company strategic priorities. If something is urgent and cross-functional, it gets fast-tracked.', team: 'all' },
      { id: 4, question: 'How do I work with a department team?', answer: 'Department directors (Casino, Tech, Data, Marketing) are embedded in your organisation. Reach out directly via Slack. No intake form needed. For cross-department work, they\'ll route it to Central Projects.', team: 'all' }
    ]));
  }
  // Render FAQ, Impact, admin lists
  renderFaqEntries();
  renderImpactEntries();
  renderAdminFaqList();
  renderAdminImpactList();
  // Render feed entries
  renderFeedEntries();
'@
$newDOMReady = $newDOMReady.Replace("`r`n","`n")
if ($c.Contains($oldDOMReady)) {
  $c = $c.Replace($oldDOMReady, $newDOMReady)
  Write-Host "✓ DOMContentLoaded updated"
} else { Write-Host "✗ DOMContentLoaded anchor not found" }

# ===== Write output =====
if ($isCRLF) { $c = $c.Replace("`n", "`r`n") }
[System.IO.File]::WriteAllText($path, $c, [System.Text.Encoding]::UTF8)
Write-Host "`n✅ update4.ps1 complete"
