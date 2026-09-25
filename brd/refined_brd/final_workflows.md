# Business Requirements Document (BRD)
## Enterprise Knowledge Base Platform (KBS)

---

### Document Control
- **Document Title:** Enterprise Knowledge Base Platform — Key Business Workflows & Scenarios
- **Document Identifier:** BRD-KBS-005 (Part 5: End-to-End Business Workflows)
- **Document Location:** `BRD_documents/05_key_business_workflows.md`
- **Target Audience:** Product Managers, Technical Leads, System Architects, UI/UX Designers, QA Engineers, Enterprise Stakeholders
- **Document Status:** Approved Product Intent / Baseline for Technical Design
- **Version:** 2.0.0 (Pure Product/Business Specification)

---

## 1. Overview & Workflow Architecture

This document defines the **six foundational business workflows** of the Enterprise Knowledge Base Platform (KBS). Each workflow details the step-by-step interaction between human actors, system interfaces, and backend business engines to ensure that business stakeholders, software engineers, and QA teams have a shared, unambiguous understanding of the platform's execution logic.

```mermaid
mindmap
  root((KBS Key Workflows))
    WF-01: Document Lifecycle & Publishing
      Template Selection
      Draft Co-Authoring
      Milestone Publication
      Deprecation & Archival
    WF-02: Real-Time Concurrent Collaboration
      Live Presence & Carets
      Conflict-Free Synchronization
      Offline Resilience
    WF-03: Knowledge Dependency & Impact Analysis
      Bidirectional Traversal
      Breaking Change Warning
      Downstream Stakeholder Alerting
    WF-04: Dynamic Access Request & Delegation
      Restricted Resource Discovery
      Just-in-Time Access Request
      Instant Live Session Transition
    WF-05: Non-Destructive Version Recovery
      Side-by-Side Visual Diff
      Safe Draft Restoration
      New Milestone Publication
    WF-06: Permission-Aware Discovery & Navigation
      Command Palette (Cmd+K)
      Security-Filtered Search
      Contextual Deep-Linking
```

---

## 2. WF-01: End-to-End Document Lifecycle & Publishing Management

### 2.1 The Big Picture (Complete Document Journey)
Every document in the organization follows a simple 5-stage lifecycle. This ensures that **readers only see finalized, approved company documents**, while **authors have a safe space to draft and update content behind the scenes**.

```mermaid
flowchart LR
    A["1️⃣ Create Draft"] --> B["2️⃣ Team Review"]
    B --> C["3️⃣ Publish Official (v1.0)"]
    C --> D["4️⃣ Safe Updates"]
    D --> E["5️⃣ Retire / Archive"]
```

---

### 2.2 Phase-by-Phase Breakdown with Simple Diagrams

---

#### 🟢 Stage 1: Creating a New Document
**Goal:** An employee starts a new document using a standardized company template or a blank page.

```mermaid
flowchart TD
    ClickNew["👤 Employee clicks 'New Document' in a Project"] --> ChooseTemplate{"Choose Starting Format"}
    ChooseTemplate -->|Option A| Template["📋 Pick a Ready Template<br/>(e.g., Project Spec, Policy, Meeting Note)"]
    ChooseTemplate -->|Option B| Blank["📝 Start Blank Page"]
    Template --> AutoDraft["💾 System starts a Private Draft<br/>(Auto-saves every keystroke)"]
    Blank --> AutoDraft
```

* **What the User Does:** The user selects where the document belongs (e.g., *Marketing Project* or *Engineering Team*) and chooses a template.
* **How the System Helps:** 
  * The document starts in **Draft Mode** (not visible to general readers yet).
  * The creator is automatically assigned as the **Document Owner**.
  * Auto-save is active from the first character, so work is never lost.

---

#### 💬 Stage 2: Team Collaboration & Getting Feedback
**Goal:** Team members work together on the draft and provide feedback before it is published.

```mermaid
sequenceDiagram
    actor Author as ✍️ Author
    actor Reviewer as 💬 Reviewer / Manager
    participant App as 📱 KBS Platform

    Author->>Reviewer: Invites Reviewer or types @Reviewer in a note
    Reviewer->>App: Highlights text and leaves a review comment
    App-->>Author: Sends instant notification with a direct link
    Author->>App: Makes requested changes & clicks "Resolve Comment"
    Note over Author,Reviewer: Draft is now polished and ready to publish!
```

* **What the User Does:** The author asks managers or team members to review specific paragraphs by tagging them (e.g., `@legal-team please verify this rule`).
* **How the System Helps:** 
  * Reviewers can add comments and suggest edits without accidentally breaking or deleting the author's work.
  * Discussion threads stay attached directly to the relevant text so context is never lost.

---

#### 🚀 Stage 3: Publishing the Official Version
**Goal:** The author releases the approved document to the company as the single source of truth.

```mermaid
flowchart TD
    ReviewDone["✅ All Review Comments Resolved"] --> ClickPublish["👤 Author clicks 'Publish Official Version'"]
    ClickPublish --> EnterNotes["📝 Enters Version Name: 'v1.0 (Approved Policy)'"]
    EnterNotes --> LiveDoc["🌟 Document is now 'v1.0 - Official'"]
    LiveDoc --> Available["👥 All authorized employees can now search & read it"]
```

* **What the User Does:** When the draft is ready, the author clicks **"Publish"** and writes a short note summarizing what the document is about.
* **How the System Helps:** 
  * The system locks in this milestone as **Version 1.0 (Official)**.
  * The document becomes fully discoverable across search and team navigation.

---

#### 🔄 Stage 4: Making Updates Without Confusing Readers
**Goal:** An author needs to update a published document, but wants to keep working in private until the new changes are approved.

```mermaid
flowchart TD
    subgraph ReadersView [What General Employees See]
        V1["📖 v1.0 Official (Published)<br/>(Always clean, verified, and safe to read)"]
    end

    subgraph AuthorsView [What Authors Edit Behind the Scenes]
        V2Draft["✏️ v1.1 Working Draft<br/>(Author makes new updates & gets reviews)"]
    end

    V2Draft -->|When Ready: Author clicks Publish| V2Live["🌟 Published as v2.0 (New Official Version)"]
    V2Live --> ReadersView
```

* **The Problem It Solves:** In older tools, editing a live document causes general staff to see incomplete sentences or work-in-progress notes.
* **How the System Helps:**
  * General readers continue to see the approved **v1.0** version.
  * Authors collaborate on a **v1.1 Draft** behind the scenes.
  * Once finalized, publishing **v2.0** smoothly replaces the old view for everyone.

---

#### 🗄️ Stage 5: Retiring Outdated Documents (Deprecation & Archiving)
**Goal:** Ensure employees never follow outdated rules or discontinued project instructions.

```mermaid
flowchart LR
    OldDoc["📄 Old Document<br/>(e.g., 2024 Travel Policy)"] --> MarkOld["👤 Owner clicks<br/>'Mark as Deprecated'"]
    MarkOld --> AddBanner["⚠️ System adds Warning Banner:<br/>'Replaced by 2026 Travel Policy'"]
    AddBanner --> Archive["🗄️ Moved to Archive<br/>(Kept for history, hidden from top search)"]
```

* **What the User Does:** When a policy or project is replaced, the owner marks it as **"Deprecated"** and links to the new document.
* **How the System Helps:**
  * Any employee opening the old link immediately sees a bold warning banner pointing to the new document.
  * When no longer needed, it is archived so company search stays clean and relevant.

---

---

## 4. WF-03: Knowledge Connections & Impact Analysis (Preventing Broken Links)

### 4.1 The Big Picture (How Documents Connect Across Teams)
In modern companies, documents rely on each other (for example, a *Payment Guide* depends on the *Security Policy*). If someone deletes or changes a policy without warning, other teams' work breaks. KBS automatically tracks all connections and warns authors before they make breaking changes.

```mermaid
flowchart LR
    A["🔗 1. Two-Way Links<br/>(Auto-tracked references)"] --> B["🗺️ 2. Visual Map<br/>(Explore relationships)"]
    B --> C["⚠️ 3. Impact Warning<br/>(Check before changing)"]
    C --> D["🔔 4. Team Alerts<br/>(Notify affected owners)"]
```

---

### 4.2 Phase-by-Phase Breakdown with Simple Diagrams

---

#### 🔗 Stage 1: Automatic Two-Way Links ("Referenced By" Panel)
**Goal:** Whenever Document A links to Document B, Document B automatically knows and displays that it is being referenced.

```mermaid
flowchart LR
    DocA["📄 'Mobile App Spec'<br/>(Types: 'See @Security-Policy')"] -->|Links to| DocB["📄 'Security Policy'"]
    DocB -.->|System Automatically Adds Backlink| SidePanel["📌 Side Panel on Security Policy:<br/>'Referenced by: Mobile App Spec'"]
```

* **What the User Does:** An author simply types `@` to link to any other company document.
* **How the System Helps:** 
  * The target document automatically gains an incoming **Backlink** in its side drawer.
  * Authors always know who is citing their work without doing any manual tracking.

---

#### 🗺️ Stage 2: Visual Knowledge Map (Exploring How Ideas Connect)
**Goal:** Give managers, new hires, and architects a visual birds-eye view of how company policies, projects, and guides connect.

```mermaid
flowchart TD
    CentralNode["📄 Core Architecture Spec"]
    CentralNode --> Leaf1["📄 Payment API Guide (Engineering)"]
    CentralNode --> Leaf2["📄 Data Privacy Policy (Legal)"]
    CentralNode --> Leaf3["📄 Mobile Checkout PRD (Product)"]

    style CentralNode fill:#4A90E2,color:#fff,stroke:#1A5276,stroke-width:2px
```

* **What the User Sees:** 
  * An interactive visual roadmap where documents appear as bubbles and links appear as connecting lines.
  * Users can zoom, search, and click any bubble to read a quick preview.
* **Why This Matters to Clients:** Helps new employees onboard in days instead of weeks by visually navigating how everything fits together.

---

#### ⚠️ Stage 3: Impact Check Before Making Major Changes
**Goal:** Prevent accidental disruptions by showing authors a safety warning before they change, rename, or retire a core document.

```mermaid
flowchart TD
    AuthorClick["👤 Author clicks 'Retire / Deprecate Document' on Auth Policy"] --> SystemScan["🔍 System checks: 'Who depends on this policy?'"]
    SystemScan --> WarningModal["⚠️ Safety Warning Modal Pops Up:<br/>'3 documents depend on this policy:<br/>1. Mobile SDK Guide (Mobile Team)<br/>2. Server Login Runbook (SecOps Team)<br/>3. Partner API Spec (Partner Team)'"]
    WarningModal --> Choice{"What would author like to do?"}
    Choice -->|Cancel| KeepSafe["🛑 Cancel and keep current policy active"]
    Choice -->|Proceed with Migration| ProvideNewDoc["📝 Provide link to New Replacement Policy"]
```

* **The Problem It Solves:** In old tools, someone changes a document and other departments only find out when their systems fail or procedures break.
* **How the System Helps:** 
  * KBS immediately flags all downstream documents and displays the names of the colleagues who own them.

---

#### 🔔 Stage 4: Automated Alerts to Affected Teams
**Goal:** When a foundational document changes or is retired, all teams relying on it are automatically notified with clear action items.

```mermaid
sequenceDiagram
    actor Author as ✍️ Policy Author
    participant App as 📱 KBS Platform
    actor MobileLead as 📱 Mobile Team Lead
    actor SecOpsLead as 🛡️ SecOps Lead

    Author->>App: Publishes replacement policy & confirms change
    
    par Automated Notifications
        App-->>MobileLead: 🔔 Alert: "Auth Policy updated! Please review your Mobile SDK Guide."
        App-->>SecOpsLead: 🔔 Alert: "Auth Policy updated! Please review your Server Login Runbook."
    end

    MobileLead->>App: Clicks notification -> Reviews new policy -> Updates guide
    SecOpsLead->>App: Clicks notification -> Reviews new policy -> Updates runbook
    Note over Author,SecOpsLead: ✨ All company documentation stays synchronized & up-to-date!
```

* **What the System Does:**
  * Sends direct notifications to all dependent document owners.
  * Provides a deep link directly to the new replacement document so they can update their instructions immediately.

---

---