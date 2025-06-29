# Tomorrow's Preferences - Daily Submission Limit

## Overview
The "Tomorrow's Preferences" feature in the polls screen now enforces a **one submission per day** policy to ensure fair participation and prevent spam submissions.

## Implementation Details

### State Management
- Added `lastPreferencesSubmissionDate` field to `PollState` model
- Tracks the date when preferences were last successfully submitted
- Persisted to local storage for data consistency across app sessions

### Provider Logic
- **`canSubmitPreferencesTodayProvider`**: Computes whether the user can submit preferences today
  - Returns `true` if user has never submitted preferences
  - Returns `true` if the last submission was on a different calendar day
  - Returns `false` if the user already submitted preferences today

### User Experience
- **Submit Button States**:
  - **Enabled**: When user has selections and hasn't submitted today
  - **Disabled**: When user has already submitted today or has no selections
  - **Loading**: Shows spinner while submission is in progress

- **Visual Feedback**:
  - Button text changes to "Submitted Today" when disabled due to daily limit
  - Button color changes to indicate disabled state
  - Informational message appears above buttons explaining the daily limit

- **Success/Error Handling**:
  - Success snackbar shows total number of preferences submitted
  - Error snackbar appears if submission fails
  - Loading state prevents multiple rapid submissions

### Technical Implementation
1. **Model Updates** (`poll_state.dart`):
   - Added `lastPreferencesSubmissionDate` field
   - Updated constructor, copyWith, toJson, and fromJson methods

2. **Provider Updates** (`poll_provider.dart`):
   - Modified `submitPreferences()` to record submission date
   - Added computed providers for submission state checking

3. **UI Updates** (`polls_screen.dart`):
   - Wrapped submit button in Consumer widget
   - Added conditional rendering based on submission state
   - Improved error handling and user feedback

### Date Logic
The system compares calendar days (not 24-hour periods):
- Submission at 11:59 PM on Day 1 allows new submission at 12:01 AM on Day 2
- Uses `DateTime(year, month, day)` for day-only comparison
- Timezone-aware based on device settings

### Future Enhancements
- Server-side validation for production deployment
- Admin override capabilities
- Customizable submission frequency (weekly, etc.)
- Analytics tracking for submission patterns
